open! Core

module Styles = [%css
  stylesheet
    {|
      .navbar {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        z-index: 1000;
        background: color-mix(in srgb, var(--bg-primary) 88%, transparent);
        backdrop-filter: blur(10px);
        border-bottom: 1px solid var(--border-color);
      }

      .nav_container {
        display: flex;
        align-items: center;
        justify-content: space-between;
        width: min(100%, 72rem);
        margin: 0 auto;
        padding: 0.85rem 1.5rem;
      }

      .nav_brand {
        color: var(--text-primary);
        text-decoration: none;
        font-size: 0.78rem;
        font-weight: 700;
        letter-spacing: 0.22em;
        text-transform: uppercase;
      }

      .nav_actions {
        display: flex;
        align-items: center;
        gap: 1.25rem;
      }

      .nav_menu {
        display: flex;
        align-items: center;
        gap: 1.5rem;
      }

      .nav_link {
        color: var(--text-primary);
        text-decoration: none;
        opacity: 0.38;
        transition: opacity 0.2s ease;
        font-size: 0.72rem;
        letter-spacing: 0.22em;
        text-transform: uppercase;
        font-weight: 500;
      }

      .active,
      .nav_link:hover,
      .mobile_nav_link:hover {
        opacity: 1;
      }

      .theme_toggle {
        border: 1px solid var(--border-strong);
        background: transparent;
        color: var(--text-primary);
        padding: 0.55rem 0.75rem;
        cursor: pointer;
        font-size: 0.72rem;
        letter-spacing: 0.22em;
        text-transform: uppercase;
        font-family: inherit;
        transition: background-color 0.2s ease, color 0.2s ease;
      }

      .theme_toggle:hover {
        background: var(--text-primary);
        color: var(--bg-primary);
      }

      .mobile_row {
        display: none;
        width: min(100%, 72rem);
        margin: 0 auto;
        padding: 0 1.5rem 0.75rem;
        align-items: center;
        justify-content: center;
        gap: 1.25rem;
        border-top: 1px solid var(--border-color);
      }

      .mobile_nav_link {
        color: var(--text-primary);
        text-decoration: none;
        opacity: 0.38;
        font-size: 0.72rem;
        letter-spacing: 0.22em;
        text-transform: uppercase;
        transition: opacity 0.2s ease;
      }

      @media (max-width: 767px) {
        .nav_container {
          padding: 0.85rem 1rem;
        }

        .nav_brand {
          font-size: 0.72rem;
          letter-spacing: 0.18em;
        }

        .nav_menu {
          display: none;
        }

        .mobile_row {
          display: flex;
        }
      }

      .nav_brand:focus-visible,
      .nav_link:focus-visible,
      .mobile_nav_link:focus-visible,
      .theme_toggle:focus-visible {
        outline: 2px solid var(--focus-ring);
        outline-offset: 2px;
      }
    |}]
