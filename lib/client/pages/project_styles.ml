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
    color: var(--text-primary);
    margin-bottom: 1rem;
    background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
    -webkit-background-clip: text;
    background-clip: text;
    -webkit-text-fill-color: transparent;
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
    border: 2px solid var(--input-border);
    border-radius: 50px;
    font-size: 1rem;
    transition: all 0.3s ease;
    background: var(--input-bg);
    color: var(--input-text);
    box-shadow: 0 2px 8px var(--card-shadow);
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
    padding: 0.625rem 1.5rem;
    border: 2px solid var(--card-border);
    background: var(--card-bg);
    color: var(--text-secondary);
    border-radius: 25px;
    font-size: 0.95rem;
    font-weight: 500;
    transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }
  
  .filter_button:hover {
    border-color: var(--gradient-start);
    color: var(--gradient-start);
    transform: translateY(-2px);
    box-shadow: 0 4px 12px var(--card-shadow-hover);
  }
  
  .filter_button.active {
    background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
    color: white;
    border-color: transparent;
    transform: scale(1.05);
  }
  
  .filter_button.active::after {
    content: "";
    position: absolute;
    top: 50%;
    left: 50%;
    width: 5px;
    height: 5px;
    background: white;
    border-radius: 50%;
    transform: translate(-50%, -50%);
    animation: ripple 0.6s ease-out;
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
    border: 2px solid transparent;
    background: linear-gradient(var(--card-bg), var(--card-bg)) padding-box,
                linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%) border-box;
  }
  
  .current_badge {
    position: absolute;
    top: 1rem;
    right: 1rem;
    background: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
    color: white;
    padding: 0.375rem 0.875rem;
    border-radius: 20px;
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
    background: #f1f5f9;
    color: #475569;
    padding: 0.25rem 0.75rem;
    border-radius: 12px;
    font-size: 0.85rem;
    font-weight: 500;
    transition: all 0.2s ease;
  }
  
  .tag:hover {
    background: #e2e8f0;
    transform: scale(1.05);
  }
  
  /* Accordion container */
  .accordion_container {
    padding: 0 1.5rem 1.5rem;
    margin-top: 1rem;
  }
  
  /* Custom accordion styling */
  .accordion_wrapper {
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    overflow: hidden;
    transition: all 0.3s ease;
  }
  
  .accordion_wrapper:hover {
    border-color: #cbd5e1;
  }
  
  .accordion_header {
    padding: 0.875rem 1.25rem;
    background: #f8fafc;
    color: #475569;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  
  .accordion_header:hover {
    background: #f1f5f9;
    color: #667eea;
  }
  
  .accordion_content {
    padding: 1.25rem;
    background: white;
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
    color: #334155;
    margin-bottom: 0.5rem;
  }
  
  .tech_stack_list {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
  }
  
  .tech_item {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 0.375rem 0.875rem;
    border-radius: 15px;
    font-size: 0.85rem;
    font-weight: 500;
  }
  
  /* Links section */
  .card_links {
    padding: 1rem 1.5rem;
    background: #f8fafc;
    display: flex;
    gap: 1rem;
  }
  
  .card_link {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    color: #667eea;
    text-decoration: none;
    font-weight: 500;
    transition: all 0.3s ease;
    padding: 0.5rem 1rem;
    border-radius: 8px;
  }
  
  .card_link:hover {
    background: white;
    transform: translateX(3px);
    box-shadow: 0 2px 8px rgba(102, 126, 234, 0.15);
  }
  
  /* Empty state */
  .empty_state {
    text-align: center;
    padding: 4rem 2rem;
    color: #94a3b8;
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
    color: #64748b;
  }
  
  .empty_message {
    font-size: 1rem;
    color: #94a3b8;
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
    border: 3px solid #e2e8f0;
    border-top-color: #667eea;
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
  
  /* Dark mode support */
  @media (prefers-color-scheme: dark) {
    .gallery {
      background: #0f172a;
    }
    
    .gallery_title {
      color: white;
    }
    
    .gallery_subtitle {
      color: #94a3b8;
    }
    
    .project_card {
      background: #1e293b;
      box-shadow: 0 4px 6px rgba(0,0,0,0.3);
    }
    
    .project_card.current {
      background: linear-gradient(#1e293b, #1e293b) padding-box,
                  linear-gradient(135deg, #667eea 0%, #764ba2 100%) border-box;
    }
    
    .card_title {
      color: white;
    }
    
    .card_description {
      color: #cbd5e1;
    }
    
    .tag {
      background: #334155;
      color: #e2e8f0;
    }
    
    .accordion_header {
      background: #334155;
      color: #e2e8f0;
    }
    
    .accordion_content {
      background: #1e293b;
      color: #cbd5e1;
    }
    
    .card_links {
      background: #334155;
    }
    
    .search_input {
      background: #1e293b;
      border-color: #334155;
      color: white;
    }
    
    .filter_button {
      background: #1e293b;
      border-color: #334155;
      color: #cbd5e1;
    }
  }
|}]