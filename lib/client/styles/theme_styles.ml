(* Theme Styles Module with CSS Variables *)
open! Core

module Styles = [%css stylesheet {|
  /* Light theme variables (default) */
  :root, .light-theme {
    /* Primary colors */
    --bg-primary: #ffffff;
    --bg-secondary: #f7fafc;
    --bg-tertiary: #edf2f7;
    
    /* Text colors */
    --text-primary: #1a202c;
    --text-secondary: #4a5568;
    --text-tertiary: #718096;
    --text-inverse: #ffffff;
    
    /* Gradient colors */
    --gradient-start: #667eea;
    --gradient-end: #764ba2;
    --gradient-start-hover: #5a67d8;
    --gradient-end-hover: #6b4299;
    
    /* Card and surface colors */
    --card-bg: #ffffff;
    --card-border: #e2e8f0;
    --card-shadow: rgba(0, 0, 0, 0.1);
    --card-shadow-hover: rgba(0, 0, 0, 0.15);
    
    /* Form colors */
    --input-bg: #ffffff;
    --input-border: #cbd5e0;
    --input-border-focus: #667eea;
    --input-text: #1a202c;
    
    /* Navigation specific */
    --nav-bg: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
    --nav-text: rgba(255, 255, 255, 0.9);
    --nav-text-hover: #ffffff;
    --nav-link-bg-hover: rgba(255, 255, 255, 0.1);
    --nav-link-bg-active: rgba(255, 255, 255, 0.2);
    
    /* Button colors */
    --btn-primary-bg: #667eea;
    --btn-primary-text: #ffffff;
    --btn-secondary-bg: transparent;
    --btn-secondary-text: #667eea;
    --btn-secondary-border: #667eea;
    
    /* Code block colors */
    --code-bg: #f7fafc;
    --code-text: #d53f8c;
    --code-border: #e2e8f0;
    
    /* Overlay */
    --overlay-bg: rgba(0, 0, 0, 0.5);
  }
  
  /* Dark theme variables */
  .dark-theme {
    /* Primary colors */
    --bg-primary: #1a202c;
    --bg-secondary: #2d3748;
    --bg-tertiary: #4a5568;
    
    /* Text colors */
    --text-primary: #f7fafc;
    --text-secondary: #cbd5e0;
    --text-tertiary: #a0aec0;
    --text-inverse: #1a202c;
    
    /* Gradient colors */
    --gradient-start: #4c51bf;
    --gradient-end: #553c9a;
    --gradient-start-hover: #434190;
    --gradient-end-hover: #4c3480;
    
    /* Card and surface colors */
    --card-bg: #2d3748;
    --card-border: #4a5568;
    --card-shadow: rgba(0, 0, 0, 0.3);
    --card-shadow-hover: rgba(0, 0, 0, 0.5);
    
    /* Form colors */
    --input-bg: #2d3748;
    --input-border: #4a5568;
    --input-border-focus: #4c51bf;
    --input-text: #f7fafc;
    
    /* Navigation specific */
    --nav-bg: linear-gradient(135deg, var(--gradient-start) 0%, var(--gradient-end) 100%);
    --nav-text: rgba(255, 255, 255, 0.9);
    --nav-text-hover: #ffffff;
    --nav-link-bg-hover: rgba(255, 255, 255, 0.1);
    --nav-link-bg-active: rgba(255, 255, 255, 0.2);
    
    /* Button colors */
    --btn-primary-bg: #4c51bf;
    --btn-primary-text: #ffffff;
    --btn-secondary-bg: transparent;
    --btn-secondary-text: #a0aec0;
    --btn-secondary-border: #4a5568;
    
    /* Code block colors */
    --code-bg: #2d3748;
    --code-text: #f687b3;
    --code-border: #4a5568;
    
    /* Overlay */
    --overlay-bg: rgba(0, 0, 0, 0.7);
  }
  
  /* Body and global styles */
  body {
    background-color: var(--bg-primary);
    color: var(--text-primary);
    transition: background-color 0.3s ease, color 0.3s ease;
  }
  
  /* Theme toggle button styles */
  .theme-toggle {
    background: rgba(255, 255, 255, 0.2);
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-radius: 50px;
    padding: 0.5rem 1rem;
    color: white;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 1rem;
    transition: all 0.3s ease;
    font-weight: 500;
  }
  
  .theme-toggle:hover {
    background: rgba(255, 255, 255, 0.3);
    border-color: rgba(255, 255, 255, 0.5);
    transform: translateY(-2px);
  }
  
  .theme-toggle:focus-visible {
    outline: 2px solid white;
    outline-offset: 2px;
  }
  
  .theme-icon {
    font-size: 1.2rem;
    display: inline-block;
    transition: transform 0.3s ease;
  }
  
  .theme-toggle:hover .theme-icon {
    transform: rotate(20deg);
  }
  
  /* Mobile responsive adjustments */
  @media (max-width: 768px) {
    .theme-toggle {
      padding: 0.4rem 0.8rem;
      font-size: 0.9rem;
    }
    
    .theme-icon {
      font-size: 1rem;
    }
  }
  
  /* Smooth transitions for theme changes */
  * {
    transition: background-color 0.3s ease, 
                color 0.3s ease, 
                border-color 0.3s ease,
                box-shadow 0.3s ease;
  }
  
  /* Override for elements that shouldn't transition */
  .no-transition,
  .no-transition * {
    transition: none !important;
  }
|}]