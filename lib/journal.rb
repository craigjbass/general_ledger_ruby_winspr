class Journal
  def initialize(date:, entries:)
    @date = date
    @entries = entries
  end

  def date
    @date
  end

  def entries
    @entries
  end

  class Entry
    def initialize(account_code:, amount:)
      @account_code = account_code
      @amount = amount
    end

    def amount
      @amount
    end

    def account_code
      @account_code
    end
  end
end
