class EntriesController < ApplicationController

    def update
        entry = Entry.find_by(id: params[:id])
        oldentry = Entry.find_by(seed: entry_params[:seed])
        oldentry.seed = entry.seed
        entry.seed = entry_params[:seed]
        entry.save
        oldentry.save
        bracket = entry.bracket
        bracket.reload()
        bracket.create_matches
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

    def destroy
        entry = Entry.find_by(id: params[:id])
        if entry.user === current_user
            bracket = entry.bracket
            entry.destroy()
            bracket.reload()
            bracket.create_matches
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

    private

    def entry_params
        params.require(:entry).permit(:seed, :id)
    end
end
