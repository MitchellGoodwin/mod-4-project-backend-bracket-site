class MatchesController < ApplicationController

    def update
        match = Match.find_by(id: params[:id])
        bracket = match.bracket
        if bracket.user === current_user
            winner = User.find_by(id: params[:winnerID])
            bracket.resolve_winner(match, winner)
            bracket.reload()
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
        else
            render json: { message: 'Not the right user' }, status: :unauthorized
        end
    end
end
