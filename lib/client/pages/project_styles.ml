(* Project Gallery Styles with ppx_css *)
open! Core

module Styles = [%css stylesheet {|
  /* Main gallery container */
  .gallery {
    padding: 4rem 2rem;
    max-width: 1400px;
    margin: 0 auto;
    animation: fadeIn 0.6s ease-out;
  }
  
  @keyframes fadeIn {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  
  /* Gallery header */
  .gallery_header {
    text-align: center;
    margin-bottom: 3rem;
  }
  
  .gallery_title {
    font-size: 2.5rem;
    font-weight: 700;
    /* Ensure text is always visible - use solid color as base */
    color: var(--text-primary);
    margin-bottom: 1rem;
    /* Optional gradient overlay for supported browsers */
    background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
    -webkit-background-clip: text;
    background-clip: text;
    -webkit-text-fill-color: transparent;
    background-size: 100% 100%;
  }
  
  .gallery_subtitle {
    font-size: 1.125rem;
    color: var(--text-secondary);
    max-width: 600px;
    margin: 0 auto;
  }
  
  /* Filter and search section */
  .controls_section {
    margin-bottom: 3rem;
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
  }
  
  /* Search bar */
  .search_container {
    position: relative;
    max-width: 500px;
    margin: 0 auto;
    width: 100%;
  }
  
  .search_input {
    width: 100%;
    padding: 0.875rem 1.25rem 0.875rem 3rem;
    border: 1px solid var(--border-color) !important;
    border-radius: 50px;
    font-size: 1rem;
    transition: all 0.3s ease;
    background: var(--input-bg);
    color: var(--input-text);
    box-shadow: 0 2px 8px var(--card-shadow);
    outline: none;
  }
  
  .search_input:focus {
    outline: none;
    border-color: var(--input-border-focus);
    box-shadow: 0 4px 12px var(--card-shadow-hover);
  }
  
  .search_icon {
    position: absolute;
    left: 1.25rem;
    top: 50%;
    transform: translateY(-50%);
    color: var(--text-tertiary);
    pointer-events: none;
  }
  
  /* Filter buttons */
  .filter_bar {
    display: flex;
    gap: 0.75rem;
    justify-content: center;
    flex-wrap: wrap;
  }
  
  .filter_button {
    padding: 0.5rem 1rem;
    border: 1px solid var(--border-color);
    background: transparent;
    color: var(--text-secondary);
    border-radius: 0.5rem;
    font-size: 0.95rem;
    font-weight: 500;
    transition: all 0.2s ease;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }
  
  .filter_button:hover {
    background: rgba(139, 92, 246, 0.1);
    border-color: #8b5cf6;
    color: #8b5cf6;
    transform: translateY(-1px);
    box-shadow: 0 2px 8px rgba(139, 92, 246, 0.2);
  }
  
  .filter_button.active {
    background: #8b5cf6;
    color: white;
    border-color: #8b5cf6;
    font-weight: 600;
    box-shadow: 0 2px 8px rgba(139, 92, 246, 0.3);
  }
  
  /* Removed ripple effect for cleaner active state */
  .filter_button.active::after {
    display: none;
  }
  
  @keyframes ripple {
    from {
      width: 5px;
      height: 5px;
      opacity: 1;
    }
    to {
      width: 100%;
      height: 100%;
      opacity: 0;
    }
  }
  
  /* Results count */
  .results_count {
    text-align: center;
    color: var(--text-tertiary);
    font-size: 0.95rem;
    margin-bottom: 2rem;
  }
  
  /* Project grid */
  .project_grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
    gap: 2rem;
    margin-bottom: 3rem;
  }
  
  /* Project card */
  .project_card {
    background: var(--card-bg);
    border: 1px solid var(--border-color) !important;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 4px 6px var(--card-shadow);
    transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
    animation: fadeInUp 0.6s ease-out backwards;
    position: relative;
  }
  
  .project_card:nth-child(1) { animation-delay: 0.1s; }
  .project_card:nth-child(2) { animation-delay: 0.15s; }
  .project_card:nth-child(3) { animation-delay: 0.2s; }
  .project_card:nth-child(4) { animation-delay: 0.25s; }
  .project_card:nth-child(5) { animation-delay: 0.3s; }
  .project_card:nth-child(6) { animation-delay: 0.35s; }
  
  @keyframes fadeInUp {
    from {
      opacity: 0;
      transform: translateY(30px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  
  .project_card:hover {
    transform: translateY(-8px);
    box-shadow: 0 20px 40px var(--card-shadow-hover);
  }
  
  .project_card.current {
    border: 2px solid #8b5cf6 !important;
    box-shadow: 0 0 0 4px rgba(139, 92, 246, 0.1), 0 4px 12px rgba(139, 92, 246, 0.2);
    background: var(--card-bg);
  }
  
  .current_badge {
    position: absolute;
    top: 1rem;
    right: 1rem;
    /* Match tech_item badge styling */
    background: rgba(139, 92, 246, 0.1);
    color: #8b5cf6;
    border: 1px solid #8b5cf6;
    padding: 0.25rem 0.5rem;
    border-radius: 0.375rem;
    font-size: 0.75rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }
  
  /* Card header */
  .card_header {
    padding: 1.5rem;
    border-bottom: 1px solid var(--card-border);
  }
  
  .card_title {
    font-size: 1.25rem;
    font-weight: 600;
    color: var(--text-primary);
    margin-bottom: 0.5rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }
  
  .card_description {
    color: var(--text-secondary);
    line-height: 1.6;
  }
  
  /* Card tags */
  .card_tags {
    padding: 0 1.5rem;
    display: flex;
    gap: 0.5rem;
    flex-wrap: wrap;
    margin-top: 1rem;
  }
  
  .tag {
    background: var(--bg-tertiary);
    color: var(--text-secondary);
    padding: 0.25rem 0.75rem;
    border-radius: 12px;
    font-size: 0.85rem;
    font-weight: 500;
    transition: all 0.2s ease;
  }
  
  .tag:hover {
    background: var(--card-border);
    transform: scale(1.05);
  }
  
  /* Accordion container */
  .accordion_container {
    padding: 0 1.5rem 1.5rem;
    margin-top: 1rem;
  }
  
  /* Custom accordion styling */
  .accordion_wrapper {
    border: 1px solid var(--card-border);
    border-radius: 8px;
    overflow: hidden;
    transition: all 0.3s ease;
  }
  
  .accordion_wrapper:hover {
    border-color: var(--input-border);
  }
  
  .accordion_header {
    padding: 0.875rem 1.25rem;
    background: var(--bg-secondary);
    color: var(--text-secondary);
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  
  .accordion_header:hover {
    background: var(--bg-tertiary);
    color: var(--gradient-start);
  }
  
  .accordion_content {
    padding: 1.25rem;
    background: var(--card-bg);
    color: var(--text-secondary);
    animation: slideDown 0.3s ease-out;
  }
  
  @keyframes slideDown {
    from {
      opacity: 0;
      transform: translateY(-10px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  
  /* Tech stack display */
  .tech_stack {
    margin-top: 1rem;
  }
  
  .tech_stack_title {
    font-weight: 600;
    color: var(--text-primary);
    margin-bottom: 0.5rem;
  }
  
  .tech_stack_list {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
  }
  
  .tech_item {
    background: rgba(139, 92, 246, 0.1);
    color: #8b5cf6;
    border: 1px solid #8b5cf6;
    padding: 0.25rem 0.5rem;
    border-radius: 0.375rem;
    font-size: 0.85rem;
    font-weight: 500;
  }
  
  /* Links section */
  .card_links {
    padding: 1rem 1.5rem;
    background: var(--bg-secondary);
    display: flex;
    gap: 1rem;
  }
  
  .card_link {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    color: var(--gradient-start);
    text-decoration: none;
    font-weight: 500;
    transition: all 0.3s ease;
    padding: 0.5rem 1rem;
    border-radius: 8px;
  }
  
  .card_link:hover {
    background: var(--bg-primary);
    transform: translateX(3px);
    box-shadow: 0 2px 8px var(--card-shadow);
  }
  
  /* Empty state */
  .empty_state {
    text-align: center;
    padding: 4rem 2rem;
    color: var(--text-tertiary);
  }
  
  .empty_icon {
    font-size: 4rem;
    margin-bottom: 1rem;
    opacity: 0.5;
  }
  
  .empty_title {
    font-size: 1.5rem;
    font-weight: 600;
    margin-bottom: 0.5rem;
    color: var(--text-secondary);
  }
  
  .empty_message {
    font-size: 1rem;
    color: var(--text-tertiary);
  }
  
  /* Loading state */
  .loading_container {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 400px;
  }
  
  .loading_spinner {
    width: 50px;
    height: 50px;
    border: 3px solid var(--card-border);
    border-top-color: var(--gradient-start);
    border-radius: 50%;
    animation: spin 1s linear infinite;
  }
  
  @keyframes spin {
    to {
      transform: rotate(360deg);
    }
  }
  
  /* Responsive design */
  @media (max-width: 768px) {
    .gallery {
      padding: 2rem 1rem;
    }
    
    .gallery_title {
      font-size: 2rem;
    }
    
    .project_grid {
      grid-template-columns: 1fr;
      gap: 1.5rem;
    }
    
    .filter_bar {
      gap: 0.5rem;
    }
    
    .filter_button {
      padding: 0.5rem 1rem;
      font-size: 0.875rem;
    }
  }
  
|}]