describe ViewJournal do
  class JournalGatewayStub
    attr_writer :journal

    def fetch_journal
      @journal
    end
  end

  let(:journal_gateway) { JournalGatewayStub.new }
  let(:view_journal) { ViewJournal.new(journal_gateway:journal_gateway) }

  it 'can view a single journal' do
    journal_gateway.journal = Journal.new(
      entries: [],
      date: Date.parse('2019-01-01')
    )

    expect(view_journal.execute(id:1)).to eq(
      id: 1,
      date: '2019/01/01',
      debits: [],
      credits: []
    )
  end

  it 'can view a single journal 2' do
    journal_gateway.journal = Journal.new(
      entries: [],
      date: Date.parse('2020-01-01')
    )

    expect(view_journal.execute(id:2)).to eq(
      id: 2,
      date: '2020/01/01',
      debits: [],
      credits: []
    )
  end

  it 'can view a single journal with entries' do
    journal_gateway.journal = Journal.new(
      entries: [
        Journal::Entry.new(
          account_code: '1234',
          amount: 24
        )
      ],
      date: Date.parse('2020-01-01')
    )

    expect(view_journal.execute(id:2)).to eq(
      id: 2,
      date: '2020/01/01',
      debits: [
        { account_code: '1234', amount: 24 }
      ],
      credits: []
    )
  end

  it 'can view a single journal with entries example 2' do
    journal_gateway.journal = Journal.new(
      entries: [
        Journal::Entry.new(
          account_code: '1337',
          amount: 42
        )
      ],
      date: Date.parse('2020-03-03')
    )

    expect(view_journal.execute(id:3)).to eq(
      id: 3,
      date: '2020/03/03',
      debits: [
        { account_code: '1337', amount: 42 }
      ],
      credits: []
    )
  end

  
  it 'can view a single journal with one credit' do
    journal_gateway.journal = Journal.new(
      entries: [
        Journal::Entry.new(
          account_code: '1337',
          amount: 42,
          type: :credit
        )
      ],
      date: Date.parse('2020-03-03')
    )

    expect(view_journal.execute(id:3)).to eq(
      id: 3,
      date: '2020/03/03',
      debits: [],
      credits: [
        { account_code: '1337', amount: 42 }
      ]
    )
  end

  it 'can view a single journal with one credit and one debit' do
    journal_gateway.journal = Journal.new(
      entries: [
        Journal::Entry.new(
          account_code: '5432',
          amount: 99,
          type: :debit
        ),
        Journal::Entry.new(
          account_code: '9999',
          amount: 99,
          type: :credit
        )
      ],
      date: Date.parse('1997-10-03')
    )

    expect(view_journal.execute(id: 4)).to eq(
      id: 4,
      date: '1997/10/03',
      debits: [
        { account_code: '5432', amount: 99 }
      ],
      credits: [
        { account_code: '9999', amount: 99 }
      ]
    )
  end
end
