defmodule DefmoduleWeb.SupervisionTree do
  @moduledoc """
  Animated supervision tree brand visual for defmodule.io — single-file,
  fully self-contained, no LiveView required.

  The component bundles its own `<style>` (crash keyframes) and `<script>`
  (randomized crash driver), so there is nothing to wire up in app.js or
  app.css. It works identically on dead views and inside LiveViews.

  ## Usage

      <DefmoduleWeb.SupervisionTree.supervision_tree id="hero-tree" />

  ## Behavior

  Every 2.5–6.5 seconds (jittered), a randomly chosen worker and its edge
  fade out and back in — a crash and supervisor restart. The same worker
  is never picked twice in a row. Visitors with
  `prefers-reduced-motion: reduce` see a static tree. Multiple instances
  on one page each animate independently.

  Note: HEEx does not apply `{}` interpolation inside `<script>` and
  `<style>` tags, so the raw JS/CSS below is safe as written.
  """
  use Phoenix.Component

  # {worker_cx, parent_cx} — parents sit at y=183, workers at cy=270.
  @workers [
    {110, 190},
    {190, 190},
    {270, 190},
    {410, 490},
    {490, 490},
    {570, 490}
  ]

  attr :id, :string, required: true
  attr :class, :string, default: nil

  def supervision_tree(assigns) do
    assigns = assign(assigns, :workers, Enum.with_index(@workers))

    ~H"""
    <style>
      @keyframes st-crash {
        0%   { opacity: 1; }
        12%  { opacity: 0.08; }
        70%  { opacity: 0.08; }
        100% { opacity: 1; }
      }
      .st-crash { animation: st-crash 1.9s ease-in-out both; }
    </style>

    <svg
      id={@id}
      data-supervision-tree
      class={@class}
      viewBox="0 0 680 330"
      width="100%"
      role="img"
      aria-labelledby={"#{@id}-title"}
      xmlns="http://www.w3.org/2000/svg"
    >
      <title id={"#{@id}-title"}>
        Supervision tree: workers crash and are restarted by their supervisors.
      </title>

      <%!-- root -> mid-supervisor edges --%>
      <line x1="340" y1="92" x2="190" y2="147" stroke="#4A4170" stroke-width="1" />
      <line x1="340" y1="92" x2="490" y2="147" stroke="#4A4170" stroke-width="1" />

      <%!-- supervisor -> worker edges --%>
      <line
        :for={{{cx, px}, i} <- @workers}
        data-worker={i}
        x1={px}
        y1="183"
        x2={cx}
        y2="256"
        stroke="#4A4170"
        stroke-width="1"
      />

      <%!-- root supervisor: the brand mark --%>
      <rect x="318" y="48" width="44" height="44" rx="11" fill="#7F77DD" />
      <text
        x="340"
        y="77"
        text-anchor="middle"
        font-size="20"
        font-weight="500"
        font-family="JetBrains Mono, ui-monospace, monospace"
        fill="#15111E"
      >
        d.
      </text>
      <text
        x="376"
        y="75"
        font-size="11"
        font-family="JetBrains Mono, ui-monospace, monospace"
        fill="#6E6788"
      >
        :one_for_one
      </text>

      <%!-- mid-level supervisors --%>
      <rect
        x="172"
        y="147"
        width="36"
        height="36"
        rx="9"
        fill="#3C3489"
        stroke="#7F77DD"
        stroke-width="1"
      />
      <rect
        x="472"
        y="147"
        width="36"
        height="36"
        rx="9"
        fill="#3C3489"
        stroke="#7F77DD"
        stroke-width="1"
      />

      <%!-- workers --%>
      <circle
        :for={{{cx, _px}, i} <- @workers}
        data-worker={i}
        cx={cx}
        cy="270"
        r="14"
        fill="#251E3A"
        stroke="#7F77DD"
        stroke-width="1"
      />
    </svg>

    <script>
      (() => {
        if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;

        const CRASH_MS = 1900; // must match the CSS animation duration above
        const MIN_DELAY_MS = 2500;
        const JITTER_MS = 4000;

        document
          .querySelectorAll("svg[data-supervision-tree]:not([data-st-init])")
          .forEach((el) => {
            el.setAttribute("data-st-init", "");
            const count = el.querySelectorAll("circle[data-worker]").length;
            let last = null;

            const schedule = () =>
              setTimeout(crash, MIN_DELAY_MS + Math.random() * JITTER_MS);

            function crash() {
              // Never the same victim twice in a row
              let v;
              do {
                v = Math.floor(Math.random() * count);
              } while (v === last && count > 1);
              last = v;

              const parts = el.querySelectorAll(`[data-worker="${v}"]`);
              parts.forEach((n) => n.classList.add("st-crash"));
              setTimeout(() => {
                parts.forEach((n) => n.classList.remove("st-crash"));
                schedule();
              }, CRASH_MS);
            }

            schedule();
          });
      })();
    </script>
    """
  end
end
