# frozen_string_literal: true
class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy, :remove_user]

  def index
    @departments = Department.all
  end

  def show; end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(department_params)

    if @department.save
      flash[:success] = 'Department successfully created.'
      redirect_to @department
    else
      flash[:danger] = @department.errors.full_messages
      render :new
    end
  end

  def edit; end

  def update
    if @department.update(department_params)
      flash[:success] = 'Department successfully updated.'
      redirect_to @department
    else
      flash[:danger] = @department.errors.full_messages
      render :edit
    end
  end

  def remove_user
    @department.users.delete(params[:user_id])
    redirect_to edit_department_path(@department)
  end

  private

  def set_department
    @department = Department.find(params[:id])
  end

  def department_params
    params.require(:department).permit(:name, user_ids: [])
  end
end
