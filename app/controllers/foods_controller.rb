class FoodsController < ApplicationController

  def index
    if params[:search]
      @foods = Usda.search(params[:search])
    else
      @foods = Usda.all
    end
  end

  def show
    @food = Usda.find(params[:id])
  end
end
