library(ggplot2)
library(dplyr)
library(cowplot)

## read data in
load("HMD_lts.rdata")


get_lmfit <- function(log_lx,year) {
    inner_dat <- data.frame(log_lx,year)
    inner_dat <- inner_dat %>% filter(log_lx!=-Inf)
   # print(inner_dat)
    res <- lm(log_lx~year,data=inner_dat)
    coefs <- res$coef
    return(coefs=coefs)
}

get_data <- function(data=dat,nation,min_year=1900,max_year=2015,lx0=0,min_age=70) {
    ## filter data for countries, years and ages
    dat_foo <- data %>%
        filter(country==nation,Year>=min_year&Year<=max_year,Age>=min_age)
   # print(head(dat_foo))
    ## set minimal lx=0 to lx0
    if(lx0!=0 & any(dat_foo$lx==0)) dat_foo$lx[dat_foo$lx==0] <- lx0
    ## calculate all of regression slopes and coefficients
    analyze <- dat_foo %>% mutate(log_lx =log(lx)) %>%
        group_by(sex,Age) %>%   summarise(intercept=get_lmfit(log_lx,Year)[1],
                                          slope=get_lmfit(log_lx,Year)[2])

    return(list(data=analyze,minimal_year=min(dat_foo$Year),maximal_year=max(dat_foo$Year)))
}



get_plotting_dimensions <- function(data,years) {
     foo <- function(intercept,slope,years) intercept+slope*years
     range(mapply(FUN=foo,intercept=data$intercept,slope=data$slope,MoreArgs=list(years)))
}


shinyServer(
    function(input, output) {

        output$coef_age <- renderPlot({
            country <- reactive({input$countries})
            min_year <- reactive({input$years[1]})
            max_year <- reactive({input$years[2]})
            min_age <- reactive({input$min_age})
            lx0 <- reactive({input$lx0})
            dats <-
                get_data(nation=country(),lx0=lx0(),min_year=min_year(),max_year=max_year(),min_age=min_age())
            Years <- dats$minimal_year:dats$maximal_year
            dat_use <- dats$data
            plot_dims <- get_plotting_dimensions(data=dat_use,years=Years)
            Survivors <- seq(plot_dims[1],plot_dims[2],length.out=10)
            sex <- c("Female","Male")
            df <- expand.grid(Years=Years,Survivors=Survivors,sex=sex)
            gp <-  ggplot(data=dat_use,aes(x=Age,y=slope,color=sex))
            plot1 <- gp+geom_line()+theme_bw()
            gp2 <- ggplot(data=df,aes(x=Years,y=Survivors))
            plot2 <-
                gp2+geom_blank()+geom_abline(aes(intercept=intercept,slope=slope,color=factor(Age)),
                                             data=dat_use)+facet_grid(sex~.)+
                                                 scale_y_continuous(breaks=c(log(1),log(100),log(10000)),labels=c(1,100,10000))+theme_bw()+
                                                     theme(legend.position="off")
            plot_grid(plot1, plot2, labels = "AUTO",ncol=1,align="v")
        },width=1000,height=1400)


    }
    )
