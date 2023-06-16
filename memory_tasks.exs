defmodule S2.Games.Memory.MemoryTasks do

  import S2.Games.Memory.MemoryUtils

  defp selected_letters(map_alphabet)  do
    vocales = get_vowels(map_alphabet, [])
    consonants = get_consonants(map_alphabet, [])
    Enum.concat(vocales, consonants)
  end

  def init_game do
    sel_letters = selected_letters(alphabet_map())
    solucion = load_board(sel_letters, alphabet_map())
    player = IO.gets("Nickname: ") |> String.trim
    game(solucion, solucion, player, 3, 0, 0)
  end

  defp game(board_on, solved_board, player, lifes, acc_v, acc_c)
      when lifes > 0 and acc_v < 3 and acc_c < 3 do
    display_board(board_on)
    IO.puts("Player: #{player}")
    IO.puts("Vowel Pairs: #{acc_v}")
    IO.puts("Consonant Pairs: #{acc_c}")
    IO.puts("Lives: #{lifes}")
    IO.puts("Enter two card numbers separated by a space (e.g., 1 2): ")
    input = IO.gets("") |> String.trim |> String.split(" ")
    case input do
      [card1, card2] when card1 in 1..12 and card2 in 1..12 ->
        case reveal_cards(board_on, card1, card2) do
          :match ->
            new_board = remove_cards(board_on, card1, card2)
            new_lifes = lifes
            new_acc_v =
              if is_vowel(Map.get(solved_board, card1)) do
                acc_v + 1
              else
                acc_v
              end
            new_acc_c =
              if is_consonant(Map.get(solved_board, card1)) do
                acc_c + 1
              else
                acc_c
              end
            if new_acc_v == 3 and new_acc_c == 3 do
              {:winner, new_acc_v + new_acc_c}
            else
              game(new_board, solved_board, player, new_lifes, new_acc_v, new_acc_c)
            end
          :mismatch ->
            IO.puts("Cards do not match!")
            game(board_on, solved_board, player, lifes - 1, acc_v, acc_c)
        end
      _ ->
        IO.puts("Invalid input! Please enter two valid card numbers.")
        game(board_on, solved_board, player, lifes, acc_v, acc_c)
    end
  end

  defp game(_, _, _, lifes, acc_v, acc_c) when lifes == 0 do
    IO.puts("Game over!")
    IO.puts("Vowel Pairs: #{acc_v}")
    IO.puts("Consonant Pairs: #{acc_c}")
    {:gameover, acc_v + acc_c}
  end

  defp game(_, _, _, _, acc_v, acc_c) do
    IO.puts("Congratulations, you found all the pairs!")
    IO.puts("Vowel Pairs: #{acc_v}")
    IO.puts("Consonant Pairs: #{acc_c}")
    {:winner, acc_v + acc_c}
  end

  defp reveal_cards(board_on, pair1, pair2) do
    letter1 = Map.get(board_on, pair1)
    letter2 = Map.get(board_on, pair2)
    IO.puts("Card #{pair1}: #{letter1}")
    IO.puts("Card #{pair2}: #{letter2}")
    if String.downcase(letter1) == String.downcase(letter2) do
      :match
    else
      :mismatch
    end
  end

end
