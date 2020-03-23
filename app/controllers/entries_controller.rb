class EntriesController < ApplicationController

    def create 
        entry = Entry.new
        bracket = Bracket.find_by(id: params[:bracket_id])
        if current_user.id == params[:user_id]
            seed = bracket.entries.size + 1
            entry.user = current_user
            entry.bracket = bracket
            entry.seed = seed
            entry.save
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
                }, :user => {
                    :only => [:id, :username]
                }})
        else
            render json: { message: 'Please log in' }, status: :unauthorized
        end
    end

    def update
        entry = Entry.find_by(id: params[:id])
        oldentry = Entry.find_by(seed: params[:seed], bracket: entry.bracket)
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
            }, :user => {
                :only => [:id, :username]
            }})
    end

    def destroy
        entry = Entry.find_by(id: params[:id])
        bracket = entry.bracket
        if entry.user === current_user || current_user === bracket.user
            entry.update_seeds_for_delete
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
            }, :user => {
                :only => [:id, :username]
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
