open! Core

module Styles = [%css
  stylesheet ~dont_hash_prefixes:[ "--" ]
    {|
      .navbar {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        z-index: 1000;
        background: var(--bg-primary);
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
        font-weight: 500;
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
        position: relative;
        display: flex;
        align-items: center;
        width: 3.5rem;
        height: 1.5rem;
        padding: 0;
        border: 1px solid var(--border-strong);
        background: transparent;
        color: var(--text-primary);
        cursor: pointer;
        font-family: inherit;
        opacity: 0.6;
        overflow: hidden;
        transition: opacity 0.2s ease;
      }

      .theme_toggle:hover {
        opacity: 1;
      }

      .theme_icon_background,
      .theme_icon_foreground {
        position: absolute;
        top: 50%;
        width: 0.75rem;
        height: 0.75rem;
        transform: translateY(-50%);
        pointer-events: none;
      }

      .theme_icon_left {
        left: 0.375rem;
      }

      .theme_icon_right {
        right: 0.375rem;
      }

      .theme_icon_background {
        z-index: 10;
      }

      .theme_slider {
        position: absolute;
        top: 0;
        bottom: 0;
        width: 50%;
        background: var(--text-primary);
        transition: transform 0.5s cubic-bezier(0.4, 0, 0.2, 1);
        transition-delay: 75ms;
      }

      .theme_slider_light {
        transform: translateX(0);
      }

      .theme_slider_dark {
        transform: translateX(100%);
      }

      .theme_icon_foreground {
        z-index: 20;
        transition: color 0.5s ease;
        transition-delay: 75ms;
      }

      .theme_icon_default {
        color: var(--text-primary);
      }

      .theme_icon_inverted {
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
