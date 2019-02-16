defmodule Miner.XPQ do
	import Floki

	def get(doc, tag) do
		doc 
		|> find(tag)
		|> text
	end
end