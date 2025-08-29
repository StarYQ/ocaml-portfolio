(* Navigation Styles Module with ppx_css *)
open! Core

module Styles = [%css stylesheet {|
  /* Main navigation bar with gradient and animations */
  .navbar {
    background: var(--nav-bg);
    padding: 1rem 2rem;
    box-shadow: 0 2px 10px var(--card-shadow);
    position: sticky;
    top: 0;
    z-index: 1000;
    animation: slideDown 0.5s cubic-bezier(0.16, 1, 0.3, 1);
    backdrop-filter: blur(10px);
    transition: all 0.3s ease;
  }
  
  @keyframes slideDown {
    from { 
      transform: translateY(-100%); 
      opacity: 0; 
    }
    to { 
      transform: translateY(0); 
      opacity: 1; 
    }
  }
  
  /* Container for nav content */
  .nav-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    max-width: 1200px;
    margin: 0 auto;
  }
  
  /* Brand/Logo section */
  .nav-brand {
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--nav-text-hover);
    text-decoration: none;
    transition: transform 0.3s ease;
  }
  
  .nav-brand:hover {
    transform: scale(1.05);
  }
  
  /* Navigation menu */
  .nav-menu {
    display: flex;
    list-style: none;
    margin: 0;
    padding: 0;
    gap: 1rem;
  }
  
  /* Navigation links with animations */
  .nav-link {
    color: var(--nav-text);
    text-decoration: none;
    padding: 0.5rem 1rem;
    border-radius: 0.25rem;
    transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
    position: relative;
    font-weight: 500;
    display: inline-block;
  }
  
  .nav-link:hover {
    color: var(--nav-text-hover);
    transform: translateY(-2px);
    background: var(--nav-link-bg-hover);
  }
  
  /* Active link with animated underline */
  .nav-link.active {
    color: var(--nav-text-hover);
    font-weight: 600;
  }
  
  .nav-link.active::after {
    content: "";
    position: absolute;
    bottom: -2px;
    left: 1rem;
    right: 1rem;
    height: 2px;
    background: var(--nav-text-hover);
    animation: slideIn 0.3s cubic-bezier(0.16, 1, 0.3, 1);
    border-radius: 1px;
  }
  
  @keyframes slideIn {
    from {
      transform: scaleX(0);
      opacity: 0;
    }
    to {
      transform: scaleX(1);
      opacity: 1;
    }
  }
  
  /* Mobile controls container */
  .mobile-controls {
    display: none;
    align-items: center;
    gap: 0.5rem;
  }
  
  /* Mobile hamburger button */
  .menu-toggle {
    display: none;
    background: none;
    border: none;
    cursor: pointer;
    padding: 0.5rem;
    position: relative;
    z-index: 1002;
  }
  
  /* SVG Hamburger icon animations */
  .hamburger-svg {
    transition: transform 0.3s ease;
  }
  
  .hamburger-svg .hamburger-line-top,
  .hamburger-svg .hamburger-line-middle,
  .hamburger-svg .hamburger-line-bottom {
    transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
    transform-origin: center;
  }
  
  /* Hamburger animation when open */
  .hamburger-svg.is-open .hamburger-line-top {
    transform: rotate(45deg) translate(6px, 6px);
  }
  
  .hamburger-svg.is-open .hamburger-line-middle {
    opacity: 0;
  }
  
  .hamburger-svg.is-open .hamburger-line-bottom {
    transform: rotate(-45deg) translate(6px, -6px);
  }
  
  /* Mobile menu panel */
  .mobile-menu {
    position: fixed;
    top: 0;
    right: -100%;
    width: 80%;
    max-width: 300px;
    height: 100vh;
    background: var(--nav-bg);
    box-shadow: -2px 0 10px var(--card-shadow);
    transition: right 0.3s cubic-bezier(0.16, 1, 0.3, 1);
    z-index: 1001;
    overflow-y: auto;
    padding: 5rem 2rem 2rem;
  }
  
  .mobile-menu.is-open {
    right: 0;
  }
  
  /* Mobile menu overlay */
  .menu-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 1000;
    opacity: 0;
    visibility: hidden;
    transition: opacity 0.3s ease, visibility 0.3s ease;
  }
  
  .menu-overlay.is-open {
    opacity: 1;
    visibility: visible;
  }
  
  /* Mobile nav items */
  .mobile-nav-items {
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }
  
  .mobile-nav-link {
    display: block;
    padding: 1rem;
    color: white;
    text-decoration: none;
    font-size: 1.1rem;
    border-radius: 0.5rem;
    transition: all 0.3s ease;
    transform: translateX(50px);
    opacity: 0;
    animation: slideInMobile 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  }
  
  .mobile-nav-link:nth-child(1) { animation-delay: 0.1s; }
  .mobile-nav-link:nth-child(2) { animation-delay: 0.15s; }
  .mobile-nav-link:nth-child(3) { animation-delay: 0.2s; }
  .mobile-nav-link:nth-child(4) { animation-delay: 0.25s; }
  .mobile-nav-link:nth-child(5) { animation-delay: 0.3s; }
  
  @keyframes slideInMobile {
    to {
      transform: translateX(0);
      opacity: 1;
    }
  }
  
  .mobile-nav-link:hover {
    background-color: rgba(255, 255, 255, 0.1);
    transform: translateX(5px);
  }
  
  .mobile-nav-link.active {
    background-color: rgba(255, 255, 255, 0.2);
    font-weight: 600;
  }
  
  /* Responsive breakpoints */
  @media (max-width: 768px) {
    .nav-menu {
      display: none;
    }
    
    .mobile-controls {
      display: flex;
    }
    
    .menu-toggle {
      display: block;
    }
    
    .theme-toggle-mobile {
      display: flex !important;
    }
    
    .theme-toggle-desktop {
      display: none;
    }
    
    .navbar {
      padding: 1rem 1.5rem;
    }
  }
  
  /* Enhanced focus states for accessibility */
  .nav-link:focus-visible,
  .mobile-nav-link:focus-visible,
  .menu-toggle:focus-visible {
    outline: 2px solid white;
    outline-offset: 2px;
  }
  
  /* Smooth scrolling behavior */
  .navbar.scrolled {
    background: linear-gradient(135deg, rgba(102, 126, 234, 0.95) 0%, rgba(118, 75, 162, 0.95) 100%);
    backdrop-filter: blur(15px);
    box-shadow: 0 4px 20px rgba(0,0,0,0.15);
  }
  
  /* Theme toggle buttons */
  .theme-toggle-desktop,
  .theme-toggle-mobile {
    background: rgba(255, 255, 255, 0.2);
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-radius: 50%;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.3s ease;
    color: white;
  }
  
  .theme-toggle-desktop:hover,
  .theme-toggle-mobile:hover {
    background: rgba(255, 255, 255, 0.3);
    border-color: rgba(255, 255, 255, 0.5);
    transform: translateY(-2px);
  }
  
  .theme-toggle-mobile {
    display: none;
    width: 40px;
    height: 40px;
  }
  
  /* Sliding theme toggle styles (legacy) */
  .theme-toggle {
    width: 60px;
    height: 30px;
    background: rgba(255, 255, 255, 0.2);
    border: 1px solid rgba(255, 255, 255, 0.3);
    border-radius: 15px;
    position: relative;
    cursor: pointer;
    transition: background 0.3s ease, border-color 0.3s ease;
    margin-left: 1rem;
    display: flex;
    align-items: center;
    padding: 0;
  }
  
  .theme-toggle:hover {
    background: rgba(255, 255, 255, 0.3);
    border-color: rgba(255, 255, 255, 0.5);
  }
  
  .theme-toggle:focus-visible {
    outline: 2px solid white;
    outline-offset: 2px;
  }
  
  /* Dark mode toggle background */
  .theme-toggle.dark {
    background: rgba(0, 0, 0, 0.3);
    border-color: rgba(255, 255, 255, 0.4);
  }
  
  /* Sliding toggle knob */
  .theme-slider {
    position: absolute;
    width: 26px;
    height: 26px;
    background: white;
    border-radius: 50%;
    top: 1px;
    left: 2px;
    transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1);
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  }
  
  /* Dark mode slider position */
  .theme-toggle.dark .theme-slider {
    transform: translateX(30px);
  }
  
  /* Icon inside the slider */
  .theme-icon {
    font-size: 14px;
    line-height: 1;
    color: #667eea;
    transition: opacity 0.3s ease;
  }
  
  .theme-toggle.dark .theme-icon {
    color: #764ba2;
  }
|}]