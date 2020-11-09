defmodule VuePhoenixWeb.PageController do
  use VuePhoenixWeb, :controller
  import Plug.Conn
  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def get_all_plants(conn, params) do
    Logger.info("In get_all_plants #{inspect params}")
    try do
      user = params["user"]
      retVal = VuePhoenix.Schemas.Plant.get_all(user)
      json(conn, retVal)
    rescue
      err ->
        Logger.error("Error retrieving all plants: #{inspect err}")
        retVal = %{ok: false, msg: "Error retrieving plants"}
        json(conn, retVal)
      end
  end

  def save_groups(conn, params) do
    Logger.info("In save_groups with params #{inspect params}")
    try do

      VuePhoenix.Schemas.Group.update_or_insert(params)
      retVal = %{ok: true, msg: "Saved groups into database"}
      json(conn, retVal)
    rescue
      err ->
        Logger.error("Error saving groups: #{inspect err}")
        retVal = %{ok: false, msg: "Error saving groups"}
        json(conn, retVal)
      end
  end

end
