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

    expect(journal_entries[0].amount).to eq(10)
    expect(journal_entries[0].account_code).to eq('1006')

    expect(journal_entries[1].amount).to eq(10)
    expect(journal_entries[1].account_code).to eq('1005')
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
    expect(journal_entries[0].amount).to eq(86)
    expect(journal_entries[0].account_code).to eq('7001001')

    expect(journal_entries[1].amount).to eq(86)
    expect(journal_entries[1].account_code).to eq('7002002')
  end
end
