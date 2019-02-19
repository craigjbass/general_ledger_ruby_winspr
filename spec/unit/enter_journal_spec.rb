describe EnterJournal do
  class JournalGatewaySpy
    attr_reader :last_journal_saved

    def save(journal)
      @last_journal_saved = journal
    end
  end

  let(:journal_gateway) { JournalGatewaySpy.new }
  let(:enter_journal) { EnterJournal.new(journal_gateway: journal_gateway) }

  let(:last_journal) { journal_gateway.last_journal_saved }
  let(:journal_entries) { last_journal.entries }

  def expect_date_to_be(expected)
    expect(last_journal.date).to eq(expected)
  end

  def journal_entry_amount_is(amount, entry_number)
    expect(journal_entries[entry_number].amount).to eq(amount)
  end

  def journal_entry_account_code_is(account_code, entry_number)
    expect(journal_entries[entry_number].account_code).to eq(account_code)
  end

  def journal_entry_is_debit(entry_number)
    expect(journal_entries[entry_number].debit?).to eq(true)
  end

  it 'can save a journal' do
    enter_journal.execute(
      date: '2019/02/02',
      debits: [
        { account_code: '1006', amount: 10 }
      ],
      credits: [
        { account_code: '1005', amount: 10 }
      ]
    )

    expect_date_to_be(Date.parse('2019-02-02'))

    journal_entry_amount_is(10, 0)
    journal_entry_account_code_is('1006', 0)

    journal_entry_amount_is(10, 1)
    journal_entry_account_code_is('1005', 1)
  end

  it 'can save a journal (example 2)' do
    enter_journal.execute(
      date: '2021/06/03',
      debits: [
        { account_code: '7001001', amount: 86 }
      ],
      credits: [
        { account_code: '7002002', amount: 86 }
      ]
    )

    expect_date_to_be(Date.parse('2021-06-03'))
    journal_entry_amount_is(86, 0)
    journal_entry_account_code_is('7001001', 0)
    journal_entry_is_debit(0)
    expect(journal_entries[1].credit?).to eq(true)
    journal_entry_amount_is(86,1)
    journal_entry_account_code_is('7002002', 1)
  end

  it 'can respond with id' do
    response = enter_journal.execute(
      date: '2021/06/03',
      debits: [
        { account_code: '7001001', amount: 86 }
      ],
      credits: [
        { account_code: '7002002', amount: 86 }
      ]
    )
    expect(response).to eq({id:nil})
  end

  it 'can save a journal with two debits' do
    enter_journal.execute(
      date: '2021/06/03',
      debits: [
        { account_code: '7001001', amount: 43 },
        { account_code: '7001009', amount: 43 }
      ],
      credits: [
        { account_code: '7002002', amount: 86 }
      ]
    )

    expect_date_to_be(Date.parse('2021-06-03'))
    journal_entry_amount_is(43, 0)
    journal_entry_account_code_is('7001001', 0)
    journal_entry_is_debit(0)
    journal_entry_amount_is(43, 1)
    journal_entry_account_code_is('7001009', 1)
    journal_entry_is_debit(1)
    expect(journal_entries[2].credit?).to eq(true)
    journal_entry_amount_is(86, 2)
  end

  it 'can save a journal with two credits' do
    enter_journal.execute(
      date: '2021/06/03',
      debits: [
        { account_code: '7001001', amount: 144 },
      ],
      credits: [
        { account_code: '7002002', amount: 72 },
        { account_code: '7002009', amount: 72 }
      ]
    )

    expect_date_to_be(Date.parse('2021-06-03'))
    journal_entry_amount_is(144, 0)
    journal_entry_account_code_is('7001001', 0)
    journal_entry_is_debit(0)
    journal_entry_amount_is(72, 1)
    journal_entry_account_code_is('7002002', 1)
    expect(journal_entries[1].credit?).to eq(true)
    expect(journal_entries[2].credit?).to eq(true)
    journal_entry_amount_is(72, 2)
    journal_entry_account_code_is('7002009', 2)
  end
end
