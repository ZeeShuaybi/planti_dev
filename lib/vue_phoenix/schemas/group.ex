defmodule VuePhoenix.Schemas.Group do
    use Ecto.Schema
    import Ecto.Changeset
    import Ecto.Query
    alias VuePhoenix.Repo
    require Logger

    schema "groups" do
        field :user, :string
        field :plant_id, :id
        field :group, :string

        timestamps()
    end

    def insert_changeset(params) do
        %__MODULE__{}
        |> cast(params, [:user, :plant_id, :group])
        |> validate_required([:user, :plant_id, :group])
    end

    def insert(params) do 
        params
        |> pipe_log("Inspecting params")
        |> insert_changeset()
        |> pipe_log("Inspecting changeset")
        |> Repo.insert()
    end

    def pipe_log(data, msg) do
        Logger.info("#{msg}:#{inspect data}")
        data
    end

    def update_or_insert(params) do
        Logger.info("In update_or_insert")
        params = for {key, val} <- params, into: %{}, do: {String.to_atom(key), val}
        if (elem(update_recs(params), 0) == 0) do
            insert(params)
        end
        removeNils()
    end

    def update_recs(params) do
        Logger.info("in update_recs")
        from(g in "groups", 
        where: g.user == ^params.user and g.plant_id == ^params.plant_id,
        select: g.group)
        |> Repo.update_all(set: [group: params.group])

    end

    def removeNils() do
        from(g in "groups", where: is_nil(g.group))
        |> Repo.delete_all
    end

end