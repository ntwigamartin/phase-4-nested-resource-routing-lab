class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user, except: [:created_at, :updated_at]
  end

  def show
    item = Item.find(params[:id])
    render json: item, except: [:created_at, :updated_at]
  end

  def create
      item = Item.create(item_params)
      render json: item, except: [:created_at, :updated_at], status: :created
  end

  private

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

  def not_found_response
    render json: { error: 'item not found' }, status: :not_found
  end
end
