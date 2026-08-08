defmodule DefmoduleWeb.Experience do
  @moduledoc """
  Homepage "experience" section for defmodule.io — a credibility device that
  sits beneath the hero. Self-contained function component (bundles its own
  scoped `<style>`), no LiveView required, works on dead views.

  ## Usage

      <DefmoduleWeb.Experience.experience_timeline />

  ## Data-driven bars

  The Gantt-style timeline is driven entirely by `@bars`. Each entry is a
  `%{name, start, finish, style, note}` map; positions are derived from the
  2011–2026 span at render time, so adjusting real dates is a data edit, not
  a markup edit. Keep it to six bars — more dilutes the specialist claim.
  """
  use Phoenix.Component

  @span_start 2011
  @span_end 2026

  # Ongoing bars use `finish: :now`; closed segments give an end year.
  @bars [
    %{name: "Production systems", start: 2016, finish: :now, style: :foundation, note: "2016 →"},
    %{name: "Elixir / OTP", start: 2020, finish: :now, style: :accent, note: "2020 →"},
    %{name: "Phoenix", start: 2020, finish: :now, style: :primary, note: "2020 →"},
    %{name: "LiveView", start: 2020, finish: :now, style: :primary, note: "2020 →"},
    %{name: "Ecto", start: 2020, finish: :now, style: :primary, note: "2020 →"},
    %{name: "IoT / PubSub", start: 2022, finish: 2023, style: :solid, note: "1 yr"},
    %{name: "Geospatial", start: 2022, finish: 2023, style: :solid, note: "1 yr"}
  ]

  @ticks [2016, 2018, 2020, 2022, 2024, 2026]

  def experience_timeline(assigns) do
    assigns =
      assigns
      |> assign(:bars, Enum.map(@bars, &compute/1))
      |> assign(:ticks, @ticks)

    ~H"""
    <style>
      .exp { --text-lo: #8B87A8; }
    </style>

    <section class="exp bg-white dark:bg-base-100">
      <div class="mx-auto max-w-3/4 px-6 pb-24 sm:pb-32 lg:px-8">
        <p class="font-mono text-lg" style="color: #7F77DD">// experience</p>

        <h2 class="font-mono text-primary-content mt-3 text-2xl font-medium text-base-content sm:text-3xl">
          Ten years in production. Six on the BEAM.
        </h2>

        <p class="mt-4 max-w-[540px] text-md text-primary-content">
          Years of sys-admin, then software in Ruby, now systems in Elixir.
        </p>

        <%!-- Timeline --%>
        <div class="mt-12 space-y-3" role="img" aria-label="Experience timeline, 2011 to 2026">
          <div
            :for={bar <- @bars}
            class="grid grid-cols-1 gap-1.5 sm:grid-cols-[130px_1fr] sm:items-center sm:gap-4"
          >
            <div class="font-mono text-[11px]" style="color: #CECBF6">{bar.name}</div>

            <div class="relative h-[22px] overflow-visible rounded-md bg-neutral">
              <div
                class="absolute inset-y-0 flex items-center justify-end rounded-md"
                style={"left: #{fmt(bar.left)}%; width: #{fmt(bar.width)}%; background: #{bar_bg(bar.style)};#{highlight(bar.style)}"}
              >
                <span
                  :if={bar.ongoing}
                  class="font-mono pr-2 text-[10px] leading-none"
                  style={"color: #{note_color(bar.style)}"}
                >
                  {bar.note}
                </span>
              </div>

              <span
                :if={!bar.ongoing}
                class="font-mono absolute top-1/2 -translate-y-1/2 pl-2 text-[10px] leading-none whitespace-nowrap"
                style={"left: #{fmt(bar.left + bar.width)}%; color: #{note_color(bar.style)}"}
              >
                {bar.note}
              </span>
            </div>
          </div>

          <%!-- X-axis ticks (evenly spaced every 3 years => flex justify-between aligns exactly) --%>
          <div class="grid grid-cols-1 gap-1.5 pt-1 sm:grid-cols-[130px_1fr] sm:gap-4">
            <div class="hidden sm:block"></div>
            <div class="font-mono flex justify-between text-[10px]" style="color: var(--text-lo)">
              <span :for={year <- @ticks}>{year}</span>
            </div>
          </div>
        </div>

        <%!-- Chip row --%>
        <%!--
        <div class="mt-8 flex flex-wrap gap-2">
          <span class="font-mono rounded-full bg-neutral px-3 py-1 text-[11px]" style="color: #CECBF6">
            Principal Architect
          </span>
          <span class="font-mono rounded-full bg-neutral px-3 py-1 text-[11px]" style="color: #CECBF6">
            LiveView since 0.x
          </span>
        </div>
        --%>
      </div>
    </section>
    """
  end

  # --- position + style helpers ---------------------------------------------

  defp compute(%{finish: :now} = bar) do
    left = offset(bar.start)
    Map.merge(bar, %{left: left, width: 100.0 - left, ongoing: true})
  end

  defp compute(%{finish: finish} = bar) do
    left = offset(bar.start)
    Map.merge(bar, %{left: left, width: offset(finish) - left, ongoing: false})
  end

  defp offset(year), do: (year - @span_start) / (@span_end - @span_start) * 100.0

  defp fmt(n), do: :erlang.float_to_binary(n * 1.0, decimals: 2)

  # Purple/accent gradients run dark -> light, left-to-right.
  defp bar_bg(:foundation), do: "linear-gradient(90deg, #1C1930 0%, #3C3489 100%)"
  defp bar_bg(:primary), do: "linear-gradient(90deg, #26215C 0%, #534AB7 100%)"
  defp bar_bg(:accent), do: "linear-gradient(90deg, #0F3B30 0%, #5DCAA5 100%)"
  defp bar_bg(:solid), do: "#3C3489"

  # The accent bar (LiveView) is the one highlighted headline offering.
  defp highlight(:accent),
    do: " box-shadow: 0 0 0 1px #5DCAA5, 0 0 14px rgba(93, 202, 165, 0.35);"

  defp highlight(_), do: ""

  defp note_color(:accent), do: "#04342C"
  defp note_color(:solid), do: "var(--text-lo)"
  defp note_color(_), do: "#CECBF6"
end
