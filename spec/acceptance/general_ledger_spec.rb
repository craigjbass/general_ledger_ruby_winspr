require 'enter_journal'
require 'view_journal'

describe 'general ledger' do
  class InMemoryJournalGateway
    def save(journal)
      @journal = journal
    end

    def fetch_journal
      @journal
    end
  end

  it 'can view a single journal' do
    journal_gateway = InMemoryJournalGateway.new
    enter_journal = EnterJournal.new(journal_gateway: journal_gateway)
    view_journal = ViewJournal.new(journal_gateway: journal_gateway)

    journal = {
      date: '2018/01/01',
      debits: [
        { account_code: '1001', amount: 100 }
      ],
      credits: [
        { account_code: '1002', amount: 100 }
      ]
    }

    response = enter_journal.execute(journal)

    expect(view_journal.execute(id: response[:id])).to(
      eq(
        id: response[:id],
        date: '2018/01/01',
        debits: [
          { account_code: '1001', amount: 100 }
        ],
        credits: [
          { account_code: '1002', amount: 100 }
        ]
      )
    )
  end
end
