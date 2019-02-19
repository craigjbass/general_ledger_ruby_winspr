class ViewJournal
  def initialize(journal_gateway:)
    @journal_gateway = journal_gateway
  end

  def execute(id:)
    journal = @journal_gateway.fetch_journal
    debits = []
    credits = []
    journal.entries.each do |entry|
      debits << {
        account_code: entry.account_code, 
        amount: entry.amount
      } if entry.debit?

      credits << {
        account_code: entry.account_code, 
        amount: entry.amount    
      } if entry.credit?
    end

    {
      id: id,
      date: formatted_date(journal.date),
      debits: debits,
      credits: credits
    }
  end

  private

  def formatted_date(date)
    date.to_s.gsub('-', '/')
  end
end
