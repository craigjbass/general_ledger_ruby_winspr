require 'journal'
require 'date'

class EnterJournal
  def initialize(journal_gateway:)
    @journal_gateway = journal_gateway
  end

  def execute(debits:, credits:, date:)
    entries = [
      Journal::Entry.new(account_code: debits[0][:account_code], amount: debits[0][:amount]),
      Journal::Entry.new(account_code: credits[0][:account_code], amount: credits[0][:amount])
    ]

    journal = Journal.new(
      date: Date.parse(date),
      entries: entries
    )

    @journal_gateway.save(journal)
    nil
  end
end
