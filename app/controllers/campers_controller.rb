class CampersController < ApplicationController

    def index
        campers = Camper.all
        render json: campers, only: [:id, :name, :age], status: :ok
    end

    def show
        camper = Camper.find(params[:id])
        render json: camper, include: [
            "activities": 
                {only: [:id, :name, :difficulty]}
            ],
            status: :ok
    rescue ActiveRecord::RecordNotFound
        render json: { error: "Camper not found" }, status: :not_found
    end

    def create
        camper = Camper.create!(camper_params)
        render json: camper, status: :created
    rescue ActiveRecord::RecordInvalid => invalid
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

    private

    def camper_params
        params.permit(:name, :age)
    end
end
