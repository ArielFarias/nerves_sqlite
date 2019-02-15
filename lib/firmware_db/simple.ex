defmodule Simple do
	import Ecto.Query

	alias FirmwareDb.Repo

	def sample_query do
		query = from w in Weather,
			where: w.prcp > ^0 or is_nil(w.prcp),
			select: w
		Repo.all(query)
	end
end
