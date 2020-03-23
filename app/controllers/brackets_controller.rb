class BracketsController < ApplicationController
    skip_before_action :authorized

    def index
        brackets = Bracket.all 
        render json: { brackets: brackets.map{|bracket| BracketsSerializer.new(bracket)} }
    end

    def show
        bracket = Bracket.find_by(id: params[:id])
        render json: bracket.to_json(only: [:id, :name, :desc, :status, :user_id], 
            :include => { :entries => {
                :only => [ :id, :seed],
                :include => {:user => {:only => [:username, :id]}}
            }, :matches => {
                :only => [:id, :round, :set],
                :include => {:user_one => {:only => [:username, :id]},
                :user_two => {:only => [:username, :id]},
                :winner => {:only => [:username, :id]}}
            }})
    end
end
