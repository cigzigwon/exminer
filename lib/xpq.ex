defmodule Miner.XPQ do
	import Floki

	def getByTag(doc, tag) do
		doc 
		|> find(tag)
		|> text
	end
end