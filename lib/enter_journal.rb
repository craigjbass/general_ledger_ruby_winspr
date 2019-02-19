require 'journal'
require 'date'

class EnterJournal
  def initialize(journal_gateway:)
    @journal_gateway = journal_gateway
  end

  def execute(debits:, credits:, date:)
    entries = [
      debits.map do |debit|
        Journal::Entry.new(
          account_code: debit[:account_code], 
          amount: debit[:amount]
        )
      end,
      credits.map do |credit|
        Journal::Entry.new(
          account_code: credit[:account_code], 
          amount: credit[:amount], 
          type: :credit
        )
      end
  ].flatten

    journal = Journal.new(
      date: Date.parse(date),
      entries: entries
    )

    @journal_gateway.save(journal)
    {id:nil}
  end
end
