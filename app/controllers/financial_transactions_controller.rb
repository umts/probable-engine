# frozen_string_literal: true
class FinancialTransactionsController < ApplicationController
  before_action :set_financial_transaction, only: [:show, :edit, :update]

  # GET /financial_transactions
  def index
    @q = FinancialTransaction.search(params[:q])
    @trans_type = FinancialTransaction.all.pluck(:transactable_type).uniq
    @financial_transactions = @q.result.paginate(page: params[:page], per_page: 10)
  end

  # GET /financial_transactions/1
  def show
  end

  def new
    @financial_transaction = FinancialTransaction.new
    @financial_transaction.rental = Rental.find(params.require(:rental_id))
    @financial_transaction.transactable_type = params.require(:transactable_type)
    @financial_transaction.transactable_id = params.require(:transactable_id)
    if !@financial_transaction.rental
      flash[:danger] = 'A rental has not been found for this financial transaction.'
    end
  end

  # GET /financial_transactions/1/edit
  def edit
    @financial_transaction.rental = Rental.find(params.require(:rental_id))
    @financial_transaction.transactable_type = params.require(:transactable_type)
    @financial_transaction.transactable_id = params.require(:transactable_id)
  end

  # POST /financial_transactions
  def create
    @financial_transaction = FinancialTransaction.new(financial_transaction_params)
    if @financial_transaction.save
      redirect_to rental_invoice_path(@financial_transaction.rental_id), success: 'Financial transaction was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /financial_transactions/1
  def update
    if @financial_transaction.update(financial_transaction_params)
      redirect_to @financial_transaction, success: 'Financial transaction was successfully updated.'
    else
      render :edit
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_financial_transaction
    @financial_transaction = FinancialTransaction.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def financial_transaction_params
    notes = params.permit(:payed_by, :payment_form).to_h.to_s
    params.require(:financial_transaction).permit(:amount, :adjustment, :rental_id, :transactable_type, :transactable_id).merge(note_field: notes)
  end
end
