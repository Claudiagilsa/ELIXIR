defmodule PiedraPapelTijera do
  def jugar() do
    jugador1 = obtener_jugada()
    jugador2 = obtener_jugada()

    resultado = calcular_resultado(jugador1, jugador2)

    IO.puts("Jugador 1 eligió: #{jugador1}")
    IO.puts("Jugador 2 eligió: #{jugador2}")
    IO.puts("Resultado: #{resultado}")
  end

  defp obtener_jugada() do
    IO.gets("Elige tu jugada (piedra, papel o tijera): ") |> String.trim() |> String.downcase()
  end

  defp calcular_resultado("piedra", "tijera"), do: "Jugador 1 gana"
  defp calcular_resultado("papel", "piedra"), do: "Jugador 1 gana"
  defp calcular_resultado("tijera", "papel"), do: "Jugador 1 gana"
  defp calcular_resultado(jugador1, jugador2) when jugador1 == jugador2, do: "Empate"
  defp calcular_resultado(_, _), do: "Jugador 2 gana"
end

PiedraPapelTijera.jugar()
