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
    def initialize(account_code:, amount:, type: :debit)
      @account_code = account_code
      @amount = amount
      @type = type
    end

    def amount
      @amount
    end
    
    def credit?
      @type == :credit
    end

    def debit?
      @type == :debit
    end

    def account_code
      @account_code
    end
  end
end
