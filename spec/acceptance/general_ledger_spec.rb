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

  def given_a_journal_with_a_date(date)
    @journal = {debits: [], credits: []}
    @journal[:date] = date
  end

  def and_a_debit_of(amount, to_account_code:)
    @journal[:debits] << { account_code: to_account_code, amount: amount }
  end

  def and_a_credit_of(amount, to_account_code:)
    @journal[:credits] << { account_code: to_account_code, amount: amount }
  end

  def when_i_view_the_journal
    journal_gateway = InMemoryJournalGateway.new
    enter_journal = EnterJournal.new(journal_gateway: journal_gateway)
    view_journal = ViewJournal.new(journal_gateway: journal_gateway)

    @response = enter_journal.execute(@journal)

    @view_journal_response = view_journal.execute(id: @response[:id])
  end

  def then_i_see_a_journal_with_date(date)
    expect(@view_journal_response).to(
      include(
        id: @response[:id],
        date: date
      )
    )
  end

  def and_it_has_a_debit_of(amount, to_account_code:)
    expect(@view_journal_response[:debits]).to include(
      { account_code: to_account_code, amount: amount }
    )
  end

  def and_it_has_a_credit_of(amount, to_account_code:)
    expect(@view_journal_response[:credits]).to include(
      { account_code: to_account_code, amount: amount }
    )
  end

  it 'can view a single journal' do
    given_a_journal_with_a_date '2018/01/01' 
    and_a_debit_of 100, to_account_code: '1001'
    and_a_credit_of 100, to_account_code: '1002'
  
    when_i_view_the_journal

    then_i_see_a_journal_with_date '2018/01/01'
    and_it_has_a_debit_of 100, to_account_code: '1001'
    and_it_has_a_credit_of 100, to_account_code: '1002'
  end

  it 'can view a single journal with multiple entries' do
    given_a_journal_with_a_date '2025/01/01' 
    and_a_debit_of 100, to_account_code: '1001'
    and_a_debit_of 50, to_account_code: '2001'
    and_a_credit_of 100, to_account_code: '1002'
    and_a_credit_of 50, to_account_code: '2002'
  
    when_i_view_the_journal

    then_i_see_a_journal_with_date '2025/01/01'
    and_it_has_a_debit_of 100, to_account_code: '1001'
    and_it_has_a_debit_of 50, to_account_code: '2001'
    and_it_has_a_credit_of 100, to_account_code: '1002'
    and_it_has_a_credit_of 50, to_account_code: '2002'
  end
end
