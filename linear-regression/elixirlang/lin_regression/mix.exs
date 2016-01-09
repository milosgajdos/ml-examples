defmodule LinRegression.Mixfile do
  use Mix.Project

  def project do
    [app: :lin_regression,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :exmatrix]]
  end

  defp deps do
    [{:exmatrix, "~> 0.0.1"}]
  end
end
