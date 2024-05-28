// This file is compiled inside Decidim core pack. Code can be added here and will be executed
// as part of that pack

// Load images
require.context("../../images", true);
import "../govbr-ds/core";
import "../animations";
import "../brazil_map_meetings";
import "../votes_rules";
import "../copy_to_clipboard";
import "../meeting";

import { contrastButtonFunc } from "../acessibility_widget";
contrastButtonFunc();

import { getNavBar } from "../submenu_navbar";
getNavBar();

import "../snippet";

//= require "jquery-ui";
