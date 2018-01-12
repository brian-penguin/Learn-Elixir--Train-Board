defmodule TimeUtil do
  use Timex

  @doc """
  Takes an epoch time(in seconds) as a string
  returns a naive_datetime or raises an error
  """
  def convert_to_naive_datetime(epoch_string) do
    epoch_string
    |> String.to_integer
    |> DateTime.from_unix!(:seconds)
    |> DateTime.to_naive
  end

  @doc """
  Takes a naive datetime
  Returns a datetime in the New York Locale (EST and EDT depending on the season)
  Trains are off here because the epoch time is taken in :local time but doesn't keep the timezone information ,
  so parsing to :local datetime will be 5 hours off
  """
  def convert_to_localtime(naive_datetime) do
    Timex.shift(naive_datetime, hours: -5)
  end

  @doc """
  Takes a naive datetime
  Returns a string representing the clock time or raise error if cant format
  ex: "6:45 PM"
  """
  def format_schedule_time(naive_datetime) do
    naive_datetime
    |> convert_to_localtime
    |> Timex.format!("%l:%M %p", :strftime)
  end

end
