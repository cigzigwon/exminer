defmodule Miner.XPath do
	import SweetXml

	def query(doc) do
		doc |> xpath(~x"//body/h1/text()")
	end
end