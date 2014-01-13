An introduction to R for visualising spatial data
========================================================
author: Robin Lovelace
date: 24th January 2014

Introduction
========================================================

During this course we will cover these topics

- An introduction to R                    (9:30 - 10:30)
- Loading and interrogating spatial data (10:30 - 11:30)
- Manipulating spatial objects (11:30 - 12:30)

LUNCH

- Making maps in ggplot2 (13:30 - 14:30)              
- Basemaps (14:30 - 15:30)
- More advanced visuals (15:30 - 16:00)

- Taking it further + Q & A (16:00 onwards)

A bit about R
========================================================

- Named after S and its creators
- De-facto standard for advanced statistical analysis
- A programming language in its own right
- The power of the command line
- Used by an increasing number of organisations

Why R?
========================================================

- **Performace**: stable, light and fast
- **Support network** 
 - documentation, community, developers
- **Reproducibility**
 - anyone anywhere can reproduce results
 - enables dissemination (RPubs, RMarkdown, .RPres) - this presentation is a .Rmd file!
- **Versatility**: unified solution to *almost* any numerical problem, graphical capabilities
- **Ethics** removes economic barrier to statistics, is open and democratic

R is up and coming I
=====================
![scholar-searches1](figure/fig_7a.png) 

Source: [r4stats.com](http://r4stats.com/articles/popularity/) 

II - Increasing popularity in academia
========================

![scholar-searches2](figure/fig_7b.png)

Source: [r4stats.com](http://r4stats.com/articles/popularity/) 

III - R vs Python
====================

![rvpytho](figure/so-rel.png)

Source: [Hadley Wickham](https://github.com/hadley/r-python)

IV - employment market
=====================

![jobs](figure/jobs.png)

Source: [revolution analytics](http://blog.revolutionanalytics.com/2013/08/job-trends-for-statistics-packages.html)


Why R for spatial data?
===================================================

- Extensive and rapidly expanding spatial packages
- Interface with 'conventional' GIS software
- The advantages of the command-line:

> "With the advent of “modern” GIS software, most people want 
> to point and click their way through life.
> That’s good, but there is a tremendous amount of 
> flexibility and power waiting for you with the command
> line. Many times you can do something on the command
> line in a fraction of the time you can do it with
> a GUI (Sherman 2008, p. 283)

Visualisation
===========================

- R's visualisation capabilities have evolved over time
- Used to create plots in the best academic journals
- ggplot2 has **revolutionised** the visualisation of quantitative 
information in R, and (possibly) overall
- Thus there are different camps with different preferences when it comes to maps in R

Why focus on visualisation?
===============

If you cannot visualise your data, it is very difficult to understand your data. 
Conversely, visualisation will greatly aid in communicating your results.

> Human beings are remarkably adept at discerning relationships from visual
> representations. A well-crafted graph can help you make meaningful comparisons among thousands of pieces of information, extracting patterns not easily found through other methods. ... Data analysts need to look at their data, and this is one area where R shines.
(Kabacoff, 2009, p. 45).

Maps, the 'base graphics' way
==========

![base graphics](figure/Choropleth_map_of_number_of_transport_nodes_in_London_boroughs.png)

Source: Cheshire and Lovelace (2014) - [available online](https://github.com/geocomPP/sdvwR)

The 'ggplot2' way of doing things
===============

![ggplot2 way](figure/Greyscale_map.png)

Source: [This tutorial](https://github.com/Robinlovelace/Creating-maps-in-R)!

R in the wild 1: Maps of all census variables for local authorities
===========

![census](figure/single.png)

R in the wild 2: Global shipping routes in the late 1700s
===========

![Dutch shipping routes](figure/dutch_shipping1750_1800.png)

Source: [R-Bloggers](http://www.r-bloggers.com/mapped-british-and-spanish-shipping-1750-1800/)

R in the wild 3: Reproducible maps of energy use in commuting
============

![engergy](figure/engenergy.png)

Energy use of commuting - my [thesis](https://github.com/Robinlovelace/thesis-reproducible) and [RPubs](http://rpubs.com/RobinLovelace/7178)


Getting up-and-running for the tutorial
===========
Any questions?

Live demonstration





