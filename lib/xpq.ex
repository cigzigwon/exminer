defmodule Miner.XPQ do
	import Floki

	def text(doc, selector) do
		doc
		|> find(selector)
		|> text
	end
end