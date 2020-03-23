class BracketsController < ApplicationController
    skip_before_action :authorized

    def index
        brackets = Bracket.all 
        render json: { brackets: brackets.map{|bracket| BracketsSerializer.new(bracket)} }
    end

    def create
        bracket = Bracket.new(bracket_params)
        bracket.status = 'pending'
        if current_user
            bracket.user = current_user
            bracket.save
            render json: bracket.to_json(only: [:id])
        else
            render json: { message: 'Please log in' }, status: :unauthorized
        end
    end

    def update
        bracket = Bracket.find_by(id: params[:id])
        bracket.status = params[:status]
        bracket.save
        render json: bracket.to_json(only: [:id, :name, :desc, :status, :user_id], 
            :include => { :entries => {
                :only => [ :id, :seed],
                :include => {:user => {:only => [:username, :id]}}
            }, :matches => {
                :only => [:id, :round, :set],
                :include => {:user_one => {:only => [:username, :id]},
                :user_two => {:only => [:username, :id]},
                :winner => {:only => [:username, :id]}}
            }, :user => {
                :only => [:id, :username]
            }
        })
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
            }, :user => {
                :only => [:id, :username]
            }
        })
    end

    private

    def bracket_params
        params.require(:bracket).permit(:name, :desc)
    end
end
