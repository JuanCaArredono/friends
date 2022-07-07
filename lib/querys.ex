defmodule Querys do
  alias Friends.{Repo, Movie}
  alias Friends.Character
  import Ecto.Query
  def get_movie(id) do
    Repo.get(Movie, id)
  end

  def get_movie_title(title) do
    Repo.get_by(Movie, title: title)
  end

  def get_all_movie do
    query = from(Movie)
    Repo.all(query)
  end

  def get_movies_bytitle(title) do
    query = from(Movie, where: [title: ^title], select: [:title, :tagline])
    Repo.all(query)
  end

  def get_title_where_id(id) do
    query = from(m in Movie, where: m.id < ^id, select: {m.title}) #se puede regresar de cualquier forma
    Repo.all(query)
  end

  def get_by_macro(id)do
    Movie
    |> where([m], m.id < ^id) #estas son las llamadas consultas basadas en palabras clave
    |> select([m], {m.title}) #Cada macro acepta un valor consultable , una lista explícita de enlaces y la misma expresión que proporcionaría a su palabra clave análoga
    |> Repo.all
  end
  def get_actors_movie()do
    query = from(m in Movie, join: a in assoc(m, :actors), preload: [actors: a])
    Repo.all(query)
  end

  def get_movies_by_actor(actor) do
    Repo.all from m in Movie,
    join: a in assoc(m, :actors),
    where: a.name == ^actor,
    preload: [actors: a]
  end
  def get_movie_character(character) do
    query = from m in Movie,
                join: c in Character,
                on: m.id == c.movie_id,
                where: c.name == ^character,
                select: {m.title, c.name}
  end

  def get_frist_last(param) when param==:frist, do: Movie |> first() |> Repo.one()
  def get_frist_last(param) when param==:last, do: Movie |> last() |> Repo.one()

end
