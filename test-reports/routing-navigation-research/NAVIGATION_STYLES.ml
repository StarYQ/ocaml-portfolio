(* NAVIGATION_STYLES.ml - ppx_css styles for navigation components *)

open! Core
open Virtual_dom
open Css_gen

(* ============================================================================
   NAVIGATION BAR STYLES
   ============================================================================ *)

module Navigation_styles = struct
  (* Main navigation bar *)
  let navbar = {css|
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem 2rem;
    background-color: var(--bg-primary);
    border-bottom: 1px solid var(--border-color);
    position: sticky;
    top: 0;
    z-index: 100;
    backdrop-filter: blur(10px);
    background-color: rgba(255, 255, 255, 0.9);
  |css}

  let navbar_dark = {css|
    background-color: rgba(20, 20, 20, 0.95);
  |css}

  (* Brand/logo section *)
  let nav_brand = {css|
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--text-primary);
    text-decoration: none;
    transition: color 0.2s ease;
  |css}

  let nav_brand_hover = {css|
    color: var(--accent-color);
  |css}

  (* Navigation menu *)
  let nav_menu = {css|
    display: flex;
    list-style: none;
    margin: 0;
    padding: 0;
    gap: 2rem;
  |css}

  (* Navigation links *)
  let nav_link = {css|
    color: var(--text-secondary);
    text-decoration: none;
    font-weight: 500;
    padding: 0.5rem 1rem;
    border-radius: 0.25rem;
    transition: all 0.2s ease;
    position: relative;
  |css}

  let nav_link_hover = {css|
    color: var(--text-primary);
    background-color: var(--bg-hover);
  |css}

  (* Active link indicator *)
  let nav_link_active = {css|
    color: var(--accent-color);
    font-weight: 600;
  |css}

  let nav_link_active_indicator = {css|
    content: "";
    position: absolute;
    bottom: -1px;
    left: 1rem;
    right: 1rem;
    height: 2px;
    background-color: var(--accent-color);
    transform: scaleX(1);
    transition: transform 0.2s ease;
  |css}
end

(* ============================================================================
   MOBILE NAVIGATION STYLES
   ============================================================================ *)

module Mobile_nav_styles = struct
  (* Hide mobile nav on desktop *)
  let mobile_navigation = {css|
    display: none;
    
    @media (max-width: 768px) {
      display: block;
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      z-index: 200;
      background-color: var(--bg-primary);
      padding: 1rem;
    }
  |css}

  (* Hamburger button *)
  let menu_toggle = {css|
    display: none;
    background: none;
    border: none;
    cursor: pointer;
    padding: 0.5rem;
    
    @media (max-width: 768px) {
      display: block;
    }
  |css}

  let hamburger_icon = {css|
    display: block;
    width: 24px;
    height: 2px;
    background-color: var(--text-primary);
    position: relative;
    transition: background-color 0.2s ease;
    
    &::before,
    &::after {
      content: "";
      position: absolute;
      width: 24px;
      height: 2px;
      background-color: var(--text-primary);
      transition: transform 0.2s ease;
    }
    
    &::before {
      top: -8px;
    }
    
    &::after {
      top: 8px;
    }
  |css}

  (* Animated hamburger when menu is open *)
  let hamburger_icon_open = {css|
    background-color: transparent;
    
    &::before {
      transform: rotate(45deg) translate(5px, 5px);
    }
    
    &::after {
      transform: rotate(-45deg) translate(5px, -5px);
    }
  |css}

  (* Mobile menu panel *)
  let mobile_menu = {css|
    position: fixed;
    top: 0;
    right: -100%;
    width: 80%;
    max-width: 300px;
    height: 100vh;
    background-color: var(--bg-primary);
    box-shadow: -2px 0 10px rgba(0, 0, 0, 0.1);
    transition: right 0.3s ease;
    z-index: 201;
    overflow-y: auto;
    padding: 2rem 1rem;
  |css}

  let mobile_menu_open = {css|
    right: 0;
  |css}

  (* Menu overlay backdrop *)
  let menu_overlay = {css|
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 200;
    animation: fadeIn 0.3s ease;
  |css}

  (* Mobile nav items *)
  let mobile_nav_items = {css|
    display: flex;
    flex-direction: column;
    gap: 1rem;
    margin-top: 2rem;
  |css}

  let mobile_nav_link = {css|
    display: block;
    padding: 1rem;
    color: var(--text-primary);
    text-decoration: none;
    font-size: 1.1rem;
    border-radius: 0.5rem;
    transition: background-color 0.2s ease;
    
    &:hover {
      background-color: var(--bg-hover);
    }
    
    &.active {
      background-color: var(--accent-bg);
      color: var(--accent-color);
      font-weight: 600;
    }
  |css}

  (* Close button *)
  let menu_close = {css|
    position: absolute;
    top: 1rem;
    right: 1rem;
    background: none;
    border: none;
    font-size: 2rem;
    color: var(--text-secondary);
    cursor: pointer;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    transition: background-color 0.2s ease;
    
    &:hover {
      background-color: var(--bg-hover);
    }
  |css}
end

(* ============================================================================
   BREADCRUMB STYLES
   ============================================================================ *)

module Breadcrumb_styles = struct
  let breadcrumb = {css|
    display: flex;
    align-items: center;
    list-style: none;
    padding: 1rem 2rem;
    margin: 0;
    background-color: var(--bg-secondary);
    border-bottom: 1px solid var(--border-color);
    font-size: 0.9rem;
    overflow-x: auto;
    white-space: nowrap;
  |css}

  let breadcrumb_item = {css|
    display: inline-flex;
    align-items: center;
    
    &:not(:last-child)::after {
      content: "/";
      margin: 0 0.75rem;
      color: var(--text-tertiary);
    }
    
    a {
      color: var(--text-secondary);
      text-decoration: none;
      transition: color 0.2s ease;
      
      &:hover {
        color: var(--accent-color);
        text-decoration: underline;
      }
    }
    
    span {
      color: var(--text-primary);
      font-weight: 500;
    }
  |css}
end

(* ============================================================================
   ROUTE TRANSITION ANIMATIONS
   ============================================================================ *)

module Transition_styles = struct
  let route_content = {css|
    animation-duration: 0.3s;
    animation-fill-mode: both;
  |css}

  let fade_enter = {css|
    animation-name: fadeIn;
    
    @keyframes fadeIn {
      from {
        opacity: 0;
        transform: translateY(10px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }
  |css}

  let fade_exit = {css|
    animation-name: fadeOut;
    
    @keyframes fadeOut {
      from {
        opacity: 1;
        transform: translateY(0);
      }
      to {
        opacity: 0;
        transform: translateY(-10px);
      }
    }
  |css}

  let slide_left_enter = {css|
    animation-name: slideLeftIn;
    
    @keyframes slideLeftIn {
      from {
        opacity: 0;
        transform: translateX(20px);
      }
      to {
        opacity: 1;
        transform: translateX(0);
      }
    }
  |css}

  let slide_right_enter = {css|
    animation-name: slideRightIn;
    
    @keyframes slideRightIn {
      from {
        opacity: 0;
        transform: translateX(-20px);
      }
      to {
        opacity: 1;
        transform: translateX(0);
      }
    }
  |css}
end

(* ============================================================================
   ADVANCED NAVIGATION PATTERNS
   ============================================================================ *)

module Advanced_nav_styles = struct
  (* Sticky sidebar navigation *)
  let sidebar_nav = {css|
    position: sticky;
    top: 5rem;
    width: 250px;
    max-height: calc(100vh - 6rem);
    overflow-y: auto;
    padding: 1rem;
    
    @media (max-width: 1024px) {
      display: none;
    }
  |css}

  let sidebar_section = {css|
    margin-bottom: 2rem;
  |css}

  let sidebar_title = {css|
    font-size: 0.875rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: var(--text-tertiary);
    margin-bottom: 0.75rem;
  |css}

  let sidebar_links = {css|
    list-style: none;
    padding: 0;
    margin: 0;
  |css}

  let sidebar_link = {css|
    display: block;
    padding: 0.5rem 0.75rem;
    color: var(--text-secondary);
    text-decoration: none;
    border-radius: 0.25rem;
    transition: all 0.2s ease;
    border-left: 2px solid transparent;
    
    &:hover {
      color: var(--text-primary);
      background-color: var(--bg-hover);
      border-left-color: var(--accent-color);
      transform: translateX(2px);
    }
    
    &.active {
      color: var(--accent-color);
      background-color: var(--accent-bg);
      border-left-color: var(--accent-color);
      font-weight: 500;
    }
  |css}

  (* Tab navigation *)
  let tab_nav = {css|
    display: flex;
    border-bottom: 2px solid var(--border-color);
    overflow-x: auto;
    white-space: nowrap;
    -webkit-overflow-scrolling: touch;
  |css}

  let tab_link = {css|
    display: inline-block;
    padding: 1rem 1.5rem;
    color: var(--text-secondary);
    text-decoration: none;
    border-bottom: 2px solid transparent;
    margin-bottom: -2px;
    transition: all 0.2s ease;
    font-weight: 500;
    
    &:hover {
      color: var(--text-primary);
      background-color: var(--bg-hover);
    }
    
    &.active {
      color: var(--accent-color);
      border-bottom-color: var(--accent-color);
    }
  |css}

  (* Floating action menu *)
  let floating_nav = {css|
    position: fixed;
    bottom: 2rem;
    right: 2rem;
    z-index: 100;
  |css}

  let floating_button = {css|
    width: 56px;
    height: 56px;
    border-radius: 50%;
    background-color: var(--accent-color);
    color: white;
    border: none;
    cursor: pointer;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    transition: all 0.2s ease;
    display: flex;
    align-items: center;
    justify-content: center;
    
    &:hover {
      transform: scale(1.1);
      box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
    }
    
    &:active {
      transform: scale(0.95);
    }
  |css}

  let floating_menu = {css|
    position: absolute;
    bottom: 70px;
    right: 0;
    background-color: var(--bg-primary);
    border-radius: 0.5rem;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    padding: 0.5rem;
    min-width: 200px;
    transform-origin: bottom right;
    animation: scaleIn 0.2s ease;
    
    @keyframes scaleIn {
      from {
        opacity: 0;
        transform: scale(0.8);
      }
      to {
        opacity: 1;
        transform: scale(1);
      }
    }
  |css}
end

(* ============================================================================
   ACCESSIBILITY STYLES
   ============================================================================ *)

module A11y_styles = struct
  (* Skip navigation link *)
  let skip_nav = {css|
    position: absolute;
    top: -40px;
    left: 0;
    background-color: var(--accent-color);
    color: white;
    padding: 0.5rem 1rem;
    text-decoration: none;
    border-radius: 0 0 0.25rem 0;
    z-index: 300;
    
    &:focus {
      top: 0;
    }
  |css}

  (* Focus visible styles *)
  let focus_visible = {css|
    &:focus-visible {
      outline: 2px solid var(--accent-color);
      outline-offset: 2px;
    }
  |css}

  (* Screen reader only *)
  let sr_only = {css|
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    margin: -1px;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    white-space: nowrap;
    border: 0;
  |css}
end

(* ============================================================================
   CSS VARIABLES FOR THEMING
   ============================================================================ *)

module Theme_variables = struct
  let root_light = {css|
    :root {
      /* Colors */
      --bg-primary: #ffffff;
      --bg-secondary: #f8f9fa;
      --bg-hover: #f1f3f5;
      --bg-active: #e9ecef;
      
      --text-primary: #212529;
      --text-secondary: #495057;
      --text-tertiary: #868e96;
      
      --accent-color: #007bff;
      --accent-bg: #e7f1ff;
      
      --border-color: #dee2e6;
      
      /* Spacing */
      --nav-height: 64px;
      --sidebar-width: 250px;
      
      /* Transitions */
      --transition-speed: 0.2s;
      --transition-easing: ease;
    }
  |css}

  let root_dark = {css|
    [data-theme="dark"] {
      --bg-primary: #1a1a1a;
      --bg-secondary: #2a2a2a;
      --bg-hover: #3a3a3a;
      --bg-active: #4a4a4a;
      
      --text-primary: #ffffff;
      --text-secondary: #b0b0b0;
      --text-tertiary: #808080;
      
      --accent-color: #4dabf7;
      --accent-bg: #1c3a52;
      
      --border-color: #404040;
    }
  |css}
end

(* ============================================================================
   RESPONSIVE UTILITIES
   ============================================================================ *)

module Responsive_styles = struct
  let hide_mobile = {css|
    @media (max-width: 768px) {
      display: none !important;
    }
  |css}

  let hide_desktop = {css|
    @media (min-width: 769px) {
      display: none !important;
    }
  |css}

  let hide_tablet = {css|
    @media (min-width: 769px) and (max-width: 1024px) {
      display: none !important;
    }
  |css}

  let container = {css|
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 1rem;
    
    @media (min-width: 768px) {
      padding: 0 2rem;
    }
    
    @media (min-width: 1200px) {
      padding: 0 3rem;
    }
  |css}
end