defmodule VuePhoenix.Schemas.Plant do
    use Ecto.Schema
    import Ecto.Changeset
    import Ecto.Query
    alias VuePhoenix.Repo
    require Logger

    schema "plants" do
        field :common_name, :string
        field :sci_name, :string
        field :family, :string
        field :is_perennial, :boolean
        field :color, :string

        timestamps()
    end

    def insert_changeset(params) do
        %__MODULE__{}
        |> cast(params, [:common_name, :sci_name, :family, :is_perennial, :color])
        |> validate_required([:sci_name, :family])
        |> unique_constraint(:sci_name)
    end

    def insert(params) do
        params
        |> insert_changeset()
        |> Repo.insert()
    end


    #select  
     # p.id,
      #(select g.group from groups g where g.plant_id = p.id and g.user = 'Zeeshan') as "group"
    #from plants p;

    def get_all(user) do
        query_user = from g in "groups",
            where: g.user == ^user,
            select: %{plant_id: g.plant_id, group: g.group}
        
        query_plants = from g in subquery(query_user),
            full_join: p in "plants",
            on: p.id == g.plant_id,
            select: %{id: p.id, common_name: p.common_name, sci_name: p.sci_name, 
                    family: p.family, is_perennial: p.is_perennial, color: p.color, group: g.group}

        Repo.all(query_plants) 
    end
    

    def pipe_log(data, msg) do
        Logger.info("#{msg}:#{inspect data}")
        data
    end
end