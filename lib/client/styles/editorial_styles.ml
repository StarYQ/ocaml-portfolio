open! Core

module Styles = [%css
  stylesheet ~dont_hash_prefixes:[ "--" ]
    {|
      .page {
        min-height: 100vh;
        background: var(--bg-primary);
        color: var(--text-primary);
      }

      .header_section {
        padding: 4rem 1.5rem 2.5rem;
        border-bottom: 1px solid var(--border-color);
      }

      .section {
        padding: 3rem 1.5rem;
        border-bottom: 1px solid var(--border-color);
      }

      .container {
        width: min(100%, 72rem);
        margin: 0 auto;
      }

      .eyebrow {
        margin: 0 0 1rem;
        color: var(--text-tertiary);
        font-size: 0.72rem;
        letter-spacing: 0.28em;
        text-transform: uppercase;
      }

      .display_title {
        margin: 0;
        font-size: clamp(4rem, 13vw, 8.75rem);
        line-height: 0.86;
        letter-spacing: -0.075em;
        font-weight: 500;
        text-transform: uppercase;
      }

      .page_title {
        margin: 0;
        font-size: clamp(3rem, 9vw, 5.5rem);
        line-height: 0.9;
        letter-spacing: -0.06em;
        font-weight: 500;
        text-transform: uppercase;
      }

      .body_text {
        margin: 0;
        color: var(--text-secondary);
        font-size: 1rem;
        line-height: 1.8;
      }

      .muted_text {
        margin: 0;
        color: var(--text-tertiary);
        font-size: 0.8rem;
        letter-spacing: 0.18em;
        text-transform: uppercase;
      }

      .section_grid {
        display: grid;
        grid-template-columns: 1fr;
        gap: 2rem;
      }

      .section_label {
        margin: 0;
        color: var(--text-tertiary);
        font-size: 0.72rem;
        letter-spacing: 0.28em;
        text-transform: uppercase;
      }

      .section_content {
        display: flex;
        flex-direction: column;
        gap: 1rem;
      }

      .button_row {
        display: flex;
        flex-wrap: wrap;
        gap: 0.75rem;
      }

      .button_primary,
      .button_secondary {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        padding: 0.9rem 1.15rem;
        border: 1px solid var(--border-strong);
        color: inherit;
        text-decoration: none;
        font-size: 0.72rem;
        letter-spacing: 0.22em;
        text-transform: uppercase;
        transition: background-color 0.2s ease, color 0.2s ease, opacity 0.2s ease;
      }

      .button_primary {
        background: var(--text-primary);
        color: var(--bg-primary);
      }

      .button_primary:hover {
        background: transparent;
        color: var(--text-primary);
      }

      .button_secondary {
        opacity: 0.65;
      }

      .button_secondary:hover {
        opacity: 1;
        background: var(--text-primary);
        color: var(--bg-primary);
      }

      .inline_link {
        color: inherit;
        text-decoration: none;
        background-image: linear-gradient(currentColor, currentColor);
        background-position: 0% 100%;
        background-repeat: no-repeat;
        background-size: 100% 1px;
        transition: background-size 0.2s ease;
      }

      .inline_link:hover {
        background-size: 100% 100%;
      }

      .photo_frame {
        width: 8rem;
        height: 10rem;
        border: 1px solid var(--border-strong);
        overflow: hidden;
        background: var(--surface-muted);
      }

      .photo_image {
        width: 100%;
        height: 100%;
        object-fit: cover;
        filter: grayscale(1);
        transition: filter 0.4s ease;
      }

      .photo_frame:hover .photo_image {
        filter: grayscale(0);
      }

      .stats_board {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        border-top: 1px solid var(--border-color);
        border-left: 1px solid var(--border-color);
      }

      .stat_cell {
        padding: 1.25rem;
        border-right: 1px solid var(--border-color);
        border-bottom: 1px solid var(--border-color);
      }

      .stat_value {
        margin: 0;
        font-size: clamp(2rem, 6vw, 3.5rem);
        line-height: 0.95;
        letter-spacing: -0.05em;
        font-weight: 500;
      }

      .stat_label {
        margin: 0.4rem 0 0;
        color: var(--text-tertiary);
        font-size: 0.72rem;
        letter-spacing: 0.24em;
        text-transform: uppercase;
      }

      .badge {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 0.45rem 0.7rem;
        border: 1px solid var(--border-color);
        color: var(--text-secondary);
        font-size: 0.72rem;
        letter-spacing: 0.18em;
        text-transform: uppercase;
      }

      .badge_strong {
        background: var(--text-primary);
        color: var(--bg-primary);
        border-color: var(--text-primary);
      }

      .stack_list {
        display: flex;
        flex-wrap: wrap;
        gap: 0.5rem;
      }

      .list_block {
        border-top: 1px solid var(--border-color);
      }

      .list_link {
        display: block;
        color: inherit;
        text-decoration: none;
        padding: 2rem 0;
        border-bottom: 1px solid var(--border-color);
        transition: background-color 0.2s ease, color 0.2s ease;
      }

      .list_link:hover {
        background: var(--text-primary);
        color: var(--bg-primary);
      }

      .secondary_grid {
        display: grid;
        grid-template-columns: 1fr;
        gap: 1px;
        background: var(--border-color);
      }

      .secondary_card {
        display: block;
        color: inherit;
        text-decoration: none;
        background: var(--bg-primary);
        padding: 1.5rem;
        transition: background-color 0.2s ease, color 0.2s ease;
      }

      .secondary_card:hover {
        background: var(--text-primary);
        color: var(--bg-primary);
      }

      .footer {
        padding: 1rem 1.5rem;
        border-top: 1px solid var(--border-color);
      }

      .footer_inner {
        width: min(100%, 72rem);
        margin: 0 auto;
        display: flex;
        flex-direction: column;
        gap: 0.75rem;
      }

      .footer_links {
        display: flex;
        flex-wrap: wrap;
        gap: 1.25rem;
      }

      .subtle_link {
        color: inherit;
        text-decoration: none;
        opacity: 0.6;
        font-size: 0.72rem;
        letter-spacing: 0.22em;
        text-transform: uppercase;
        transition: opacity 0.2s ease;
      }

      .subtle_link:hover {
        opacity: 1;
      }

      .back_link {
        color: inherit;
        text-decoration: none;
        opacity: 0.7;
        font-size: 0.72rem;
        letter-spacing: 0.24em;
        text-transform: uppercase;
        transition: opacity 0.2s ease;
      }

      .back_link:hover {
        opacity: 1;
      }

      @media (min-width: 768px) {
        .header_section {
          padding: 5rem 2rem 3rem;
        }

        .section {
          padding: 3.5rem 2rem;
        }

        .section_grid {
          grid-template-columns: minmax(12rem, 16rem) minmax(0, 1fr);
          gap: 3rem;
        }

        .stats_board {
          grid-template-columns: repeat(4, minmax(0, 1fr));
        }

        .secondary_grid {
          grid-template-columns: repeat(2, minmax(0, 1fr));
        }

        .footer_inner {
          flex-direction: row;
          align-items: center;
          justify-content: space-between;
        }
      }
    |}]
