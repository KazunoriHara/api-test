class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :add]
  before_action :set_user_array, only: [:lottery]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    if @user
      res = 0
      area = @user.name
    else
      res = 1
      area = ""
    end
    render json: {result: res, message: area}
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  # POST /users/:id/:name
  def add
    if @user 
      res = 1
    else 
      User.create({user_id: params[:id], name: params[:name]})
      res = 0
    end
    render json: {result: res}
  end

  # GET /lottery
  def lottery
    array_count = @user.count
    if array_count > 0
      id_array = []
      @user.each{
        |element|
        id_array.push(element.user_id)
      }
      rnd = rand(array_count)
      user_name = @user[rnd].name
      render json: {result: user_name}
    else
      render json: {result: 'Data is Empty'}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by(user_id: params[:id])
    end

    def set_user_array
      #レコードを最大100件まで取得する
      User.find_in_batches(batch_size: 100){
        |user_array|
        @user = user_array
      }
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:user_id, :name)
    end
end
