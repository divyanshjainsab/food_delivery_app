class ReviewsController < ApplicationController
    def new
        redirect_to root_path unless Payment.find_by_payment_intent_id params[:pid]
        @rid = params[:r_id]
        @review = Review.new
    end

    def create
        review = Review.new review_params
        review.client_id = get_id
        if review.save!
            flash[:notice] = "Review added successfully"
        else
            flash[:notice] = "Review cannot be added."
        end

        redirect_to user_orders_path
    end

    private
    def review_params
        params.require(:review).permit( %i[ title description rating restaurant_id ] )
    end
end
