class RatingsController < ApplicationController
  #before_action :set_rating, :redirect_if_not_owner, only: [:show, :edit, :update, :destroy]
  before_action :require_logged_in
  before_action :set_rating, except: [:index, :new, :create, :destroy]
  
  
  def create
    @book = params[:book_id] && @book = Book.find_by_id(params[:book_id])
    #@rating.book_id = @book_id
    @rating = current_user.ratings.build(rating_params)
    
    if @rating.save
      #both .save and .valid will run the validations and populate the errors
      #redirect is a new get request so it's a new instance of the controller
      redirect_to rating_path(@rating)
    else
      #if we want to hold on to instance variable, you have to use render
      render :new
    end
  end 

  def new
    #@rating = Rating.new
    #check if this is a nested route?
    if params[:book_id] && @book = Book.find_by_id(params[:book_id])
      @rating = @book.ratings.build
      #@rating.book = @book
      #@rating = Rating.new(brand_id: params(:build_id))
      #what are some ways we can make a new shoe and associate it with a brand
      #if so, we only want ratings of that book
      #access just ratings of this book
      #pre associating the rating to the book if you come from a nested form 
      #@ratings = @book.ratings.ordered_by_number
    else 
        ##@ratings = Rating.ordered_by_number
        @rating = Rating.new
        @rating.build_book
        #if not
        #show all the ratings @ratings = Rating.ordered_by_number
      end 
  end

  def show
    @rating = Rating.find(params[:id])
  end

  def index
    
    #first, check if this is a nested route 
    #access just ratings of this book
    #if so, we only want ratings of that book
    if params[:book_id] && @book = Book.find_by_id(params[:book_id]) 
      @ratings = @book.ratings.ordered_by_number
    else 
      #flash[:message] = "This book does not exist! Here are all ratings."
      
      @ratings = Rating.ordered_by_number
      #if not, show all the ratings @ratings = Rating.ordered_by_number
    end 
    end
  
  def edit
    @rating = Rating.find(params[:id])
    if current_user != @rating.user
      flash[:message] = "You can't edit a rating you did not create."
      redirect_to rating_path(current_user) 
    end
    end
  
  def update
    @rating = Rating.find(params[:id])
    @rating.update(number:params[:rating][:number], comment:params[:rating][:comment])
    redirect_to rating_path(@rating)
  end

  def destroy
    @rating = Rating.find(params[:id])
   
    
    if current_user == @rating.user
      @rating.destroy
    else
      flash[:message] = "You can't edit a rating you did not create."
    end
    redirect_to user_path(current_user) 
    
end
    
  def highest
    @rating = Rating.ordered_by_number.first
  end

private

  def set_rating
    @rating = Rating.find(params[:id])
  end

  def rating_params
    params.require(:rating).permit(:book_id, :number, :comment)
  end

  def require_logged_in
  return redirect_to root_path unless logged_in?
  end

end

