defmodule ParesNones do
  def jugar() do
    IO.puts("Bienvenido a Pares o Nones!")
    jugador1 = obtener_jugada()
    jugador2 = obtener_jugada()

    resultado = calcular_resultado(jugador1, jugador2)

    IO.puts("Jugador 1 eligió: #{jugador1}")
    IO.puts("Jugador 2 eligió: #{jugador2}")
    IO.puts("Resultado: #{resultado}")
  end

  defp obtener_jugada() do
    IO.gets("Elige pares (p) o nones (n): ")
    |> String.trim()
    |> String.downcase()
    |> validar_jugada()
  end

  defp validar_jugada(jugada) do
    if jugada == "p" || jugada == "n" do
      jugada
    else
      IO.puts("Jugada inválida. Inténtalo nuevamente.")
      obtener_jugada()
    end
  end

  defp calcular_resultado("p", "n"), do: "Jugador 1 gana"
  defp calcular_resultado("n", "p"), do: "Jugador 2 gana"
  defp calcular_resultado(_, _), do: "Empate"
end

ParesNones.jugar()
