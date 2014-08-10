check_library <- function(package) {
	if (package %in% rownames(installed.packages()) == FALSE) {
		install.packages(package, repos = "http://cran.gis-lab.info/", dependencies = TRUE)
	} 
}

get_period <- function(data) {
	period = max(data$Date) - min(data$Date) + 1
	return(period)
}

get_dates_seq <-function(data) {
	period = get_period(data)
	dates = seq(as.Date(min(data$Date), format = "%d.%m.%Y"), by = "days", length = period)
	return(dates)
}

get_plot_breaks <- function(period) {
	if (period < 32) {
		return("1 day")
	} else {
		return("1 week")
	}
}

draw_costs <- function(data, cost_name, tags) {
	period = get_period(data);
	dates = get_dates_seq(data)

	costs <- rep(0.0, period)
	sum = 0.0
	for (i in 1:nrow(data)) {
		wage = data$Amount[i]	
		if (sum(stri_detect_fixed(data$Place[i], tags)) > 0) {
			id = which(dates == data$Date[i])
			costs[id] = costs[id] - wage
		}
	}

	nonzero_costs = costs[which(costs > 0.0)]
	plot_title = paste(
		" Total = ", round(sum(nonzero_costs)), 
		" Mean = ", round(mean(nonzero_costs)), 
		" Min = ", min(nonzero_costs), 
		" Max = ", max(nonzero_costs),
		sep = "") 

	plot_data = data.frame(dates, costs)

	ggplot(plot_data, aes(x = dates, y = costs)) + 
	geom_histogram(stat = "identity", aes(fill = costs)) + 
	scale_fill_gradient("", low = "lawngreen", high = "seagreen") +
	ggtitle(plot_title) + 
 	theme(plot.title = element_text(lineheight = .8, face = "bold")) +
	xlab("") +
	ylab("") +
	scale_x_date(breaks = get_plot_breaks(period), labels = date_format("%d.%m.%Y")) +
	theme(axis.text.x = element_text(angle = 90, hjust = 1.2))

	plot_width = max(c(6, period*0.05))
	file_name = paste("output/", cost_name, ".png", sep = "")
	ggsave(file = file_name, height = 4, width = plot_width)
}

args <- commandArgs(TRUE)
argc = length(args)
if (argc < 1) {
	print ("Please provide at least one csv file\n")
	q()
}

data <- data.frame(
	Date = as.Date(character(), "%d.%m.%Y"), 
	Date2 = as.Date(character(), "%d.%m.%Y"), 
	Place = character(), 
	Amount = as.double(character())) 

for (i in 1:argc) {
	csv <- read.csv(file = args[i], sep = ";")
	csv$Date <- as.Date(csv$Date, "%d.%m.%Y")
	csv$Date2 <- as.Date(csv$Date2, "%d.%m.%Y")
	for (j in 1:nrow(csv)) {
		if (is.na(csv$Date[j])) {
			csv$Date[j] = csv$Date2[j]
		}
	}
	csv$Amount <- as.double(csv$Amount)
	data <- rbind(data, csv[, c("Date", "Date2", "Place", "Amount")])
}

check_library("ggplot2")
library("ggplot2")
check_library("scales")
library("scales")
check_library("stringi")
library("stringi")
check_library("stringr")
library("stringr")

categories_file = file("categories.txt", open = "r")
lines = readLines(categories_file)
for (i in 1:length(lines)){
	category_raw = unlist(strsplit(lines[i], "=", fixed = TRUE))
	category_name = str_trim(category_raw[1])
	category_tags = unlist(strsplit(category_raw[2], "+", fixed = TRUE))
	for (i in 1:length(category_tags)) {
		category_tags[i] = str_trim(category_tags[i])
	}
	draw_costs(data, category_name, category_tags)
}
close(categories_file)

