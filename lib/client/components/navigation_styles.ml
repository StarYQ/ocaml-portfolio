(* Navigation Styles Module with ppx_css *)
open! Core

module Styles = [%css stylesheet {|
  /* Main navigation bar with gradient and animations */
  .navbar {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    padding: 1rem 2rem;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
    color: white;
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
    color: rgba(255, 255, 255, 0.9);
    text-decoration: none;
    padding: 0.5rem 1rem;
    border-radius: 0.25rem;
    transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
    position: relative;
    font-weight: 500;
    display: inline-block;
  }
  
  .nav-link:hover {
    color: white;
    transform: translateY(-2px);
    background: rgba(255, 255, 255, 0.1);
  }
  
  /* Active link with animated underline */
  .nav-link.active {
    color: white;
    font-weight: 600;
  }
  
  .nav-link.active::after {
    content: "";
    position: absolute;
    bottom: -2px;
    left: 1rem;
    right: 1rem;
    height: 2px;
    background: white;
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
  
  .hamburger {
    display: block;
    width: 24px;
    height: 2px;
    background-color: white;
    position: relative;
    transition: background-color 0.3s ease;
  }
  
  .hamburger::before,
  .hamburger::after {
    content: "";
    position: absolute;
    width: 24px;
    height: 2px;
    background-color: white;
    transition: transform 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
  }
  
  .hamburger::before {
    top: -8px;
  }
  
  .hamburger::after {
    top: 8px;
  }
  
  /* Hamburger animation when open */
  .hamburger.is-open {
    background-color: transparent;
  }
  
  .hamburger.is-open::before {
    transform: rotate(45deg) translate(5px, 5px);
  }
  
  .hamburger.is-open::after {
    transform: rotate(-45deg) translate(7px, -8px);
  }
  
  /* Mobile menu panel */
  .mobile-menu {
    position: fixed;
    top: 0;
    right: -100%;
    width: 80%;
    max-width: 300px;
    height: 100vh;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    box-shadow: -2px 0 10px rgba(0, 0, 0, 0.2);
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
    
    .menu-toggle {
      display: block;
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
|}]