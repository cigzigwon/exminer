defmodule Miner.XPQ do
	import Floki

	def get(doc, selector) do
		doc
		|> find(selector)
		|> text
	end
end