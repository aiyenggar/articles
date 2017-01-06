local imagedir  /Users/aiyenggar/OneDrive/code/articles/ot-term-paper-images/
import delimited "/Users/aiyenggar/OneDrive/code/agent/embeddedAgency.csv", delimiter(comma) varnames(1) encoding(ISO-8859-1) clear

label variable period "Time Period"
save "/Users/aiyenggar/OneDrive/code/agent/embeddedAgency.dta", replace
// SELECTED
// Slow learners initially do better than the fast learners when units are strongly aligned
// Medium learners do almost as well as the fast learners
graph twoway (connected  frcmediumurslow period if period <= 30) ///
	(line  frcmediumurmedium period if period <= 30) ///
	(line  frcmediumurfast period if period <= 30), ///
	ytitle("Average Score") xtitle("Time Period") /// 
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Field Start is Right of Center (0.75)") ///
	legend(cols(1) label(1 Start: Aligned, (FLR, ALR) = (Medium, Slow)) label(2 Start: Aligned, (FLR, ALR) = (Medium, Medium)) label(3 Start: Aligned, (FLR, ALR) = (Medium, Fast)))
graph2tex, epsfile(`imagedir'frcmedium1) ht(5) caption(Field is Right of Center with Medium Learning Rate)

// With medium learning, the adversely aligned agent falls in line
graph twoway (line  frcmediumulmedium period) ///
	(line  frcmediumurmedium period) ///
	(line  frcmediumucmedium period), ///
	ytitle("Average Score") xtitle("Time Period") /// 
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Variation by Alignment in Units with Medium Learning") ///
	legend(cols(1) label(1 Agent is Adversely Aligned) label(2 Agent is Aligned) label(3 Agent is Agnostic))
graph2tex, epsfile(`imagedir'frcmedium2a) ht(5) caption(Field is Right of Center with Medium Learning Rate)

graph twoway (line  frcmediumulslow period) ///
	(line  frcmediumurslow period) ///
	(line  frcmediumucslow period), ///
	ytitle("Average Score") xtitle("Time Period") /// 
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Variation by Alignment in Units with Slow Learning") ///
	legend(label(1 Agent is Adversely Aligned) label(2 Agent is Aligned) label(3 Agent is Agnostic))
graph2tex, epsfile(`imagedir'frcmedium2b) ht(5) caption(Field is Right of Center with Medium Learning Rate)

graph twoway (line  frcmediumulfast period) ///
	(line  frcmediumurfast period) ///
	(line  frcmediumucfast period), ///
	ytitle("Average Score") xtitle("Time Period") /// 
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Variation by Alignment in Units with Fast Learning") ///
	legend(label(1 Agent is Adversely Aligned) label(2 Agent is Aligned) label(3 Agent is Agnostic))
graph2tex, epsfile(`imagedir'frcmedium2c) ht(5) caption(Field is Right of Center with Medium Learning Rate)

// all 9 combinations
graph twoway (line  frcmediumulslow period) ///
	(line  frcmediumurslow period) ///
	(connected  frcmediumucslow period) ///
	 (line  frcmediumulmedium period) ///
	(line  frcmediumurmedium period) ///
	(connected  frcmediumucmedium period) ///
	(line  frcmediumulfast period) ///
	(line  frcmediumurfast period) ///
	(connected  frcmediumucfast period), ///
	ytitle("Average Score") xtitle("Time Period") /// 
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Variation by Alignment in Units with Slow Learning") ///
	legend(label(1 Adversely Aligned Slow Learner) label(2 Aligned Slow Learner) label(3 Agnostic Slow Learner) label(4 Adversely Aligned Medium Learner) label(5 Aligned Medium Learner) label(6 Agnostic Medium Learner) label(7 Adversely Aligned Fast Learner) label(8 Aligned Fast Learner) label(9 Agnostic Fast Learner))
graph2tex, epsfile(`imagedir'frcmedium2) ht(5) caption(Field is Right of Center with Medium Learning Rate)


// SELECTED
// Main result, that in Fields with Medium Learning rate and a Right of Center positioning Adversely Aligned Slow Learning agents come out better than the others
graph twoway (connected  frcmediumulslow period if period <= 20) ///
	(line  frcmediumucslow period if period <= 20) ///
	(connected  frcslowulslow period if period <= 20) ///
	(line  frcslowucslow period if period <= 20), ///
	ytitle("Average Score") xtitle("Time Period") /// 
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Field Start is Right of Center (0.75)") ///
	note("FLR: Field Learning Rate, ALR: Agent Learning Rate") ///
	legend(cols(1) label(1 Start: Adversarial, (FLR, ALR) = (Medium, Slow))  label(2 Start: Agnostic, (FLR, ALR) = (Medium, Slow)) label(3 Start: Adversarial, (FLR, ALR) = (Slow, Slow)) label(4 Start: Agnostic, (FLR, ALR) = (Slow, Slow)))
graph2tex, epsfile(`imagedir'frcmedium3a) ht(5) caption(Field is Right of Center)

// SELECTED
graph twoway (connected  frmediumulslow period if period <= 20) ///
	(line  frmediumucslow period if period <= 20) ///
	(connected  frslowulslow period if period <= 20) ///
	(line  frslowucslow period if period <= 20), ///
	ytitle("Average Score") xtitle("Time Period") /// 
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Field Start is Right (0.95)") ///
	note("FLR: Field Learning Rate, ALR: Agent Learning Rate") ///
	legend(cols(1) label(1 Start: Adversarial, (FLR, ALR) = (Medium, Slow))  label(2 Start: Agnostic, (FLR, ALR) = (Medium, Slow)) label(3 Start: Adversarial, (FLR, ALR) = (Slow, Slow)) label(4 Start: Agnostic, (FLR, ALR) = (Slow, Slow)))
graph2tex, epsfile(`imagedir'frcmedium3b) ht(5) caption(Field is Right of Center)

// SELECTED
graph twoway (connected  frmediumulmedium period if period <= 20) ///
	(line  frmediumucmedium period if period <= 20) ///
	(connected  frslowulmedium period if period <= 20) ///
	(line  frslowucmedium period if period <= 20), ///
	ytitle("Average Score") xtitle("Time Period") /// 
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Field Start is Right (0.95)") ///
	legend(cols(1) label(1 Start: Adversarial, (FLR, ALR) = (Medium, Medium))  label(2 Start: Agnostic, (FLR, ALR) = (Medium, Medium)) label(3 Start: Adversarial, (FLR, ALR) = (Slow, Medium)) label(4 Start: Agnostic, (FLR, ALR) = (Slow, Medium)))
graph2tex, epsfile(`imagedir'frcmedium3c) ht(5) caption(Field is Right of Center)

// SELECTED
graph twoway (line  frmediumulfast period if period <= 30) ///
	(connected  frmediumucfast period if period <= 30) ///
	(line  frslowulfast period if period <= 30) ///
	(connected  frslowucfast period if period <= 30), ///
	ytitle("Average Score") xtitle("Time Period") /// 
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Field Start is Right (0.95)") ///
	note("FLR: Field Learning Rate, ALR: Agent Learning Rate") ///
	legend(cols(1) label(1 Start: Adversarial, (FLR, ALR) = (Medium, Fast))  label(2 Start: Agnostic, (FLR, ALR) = (Medium, Fast)) label(3 Start: Adversarial, (FLR, ALR) = (Slow, Fast)) label(4 Start: Agnostic, (FLR, ALR) = (Slow, Fast)))
graph2tex, epsfile(`imagedir'frcmedium3d) ht(5) caption(Field is Right of Center)

// SELECTED
graph twoway (line  frcmediumulfast period if period <= 30) ///
	(connected  frcmediumucfast period if period <= 30) ///
	(line  frcslowulfast period if period <= 30) ///
	(connected  frcslowucfast period if period <= 30), ///
	ytitle("Average Score") xtitle("Time Period") /// 
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Field Start is Right of Center (0.75)") ///
	note("FLR: Field Learning Rate, ALR: Agent Learning Rate") ///
	legend(cols(1) label(1 Start: Adversarial, (FLR, ALR) = (Medium, Fast))  label(2 Start: Agnostic, (FLR, ALR) = (Medium, Fast)) label(3 Start: Adversarial, (FLR, ALR) = (Slow, Fast)) label(4 Start: Agnostic, (FLR, ALR) = (Slow, Fast)))
graph2tex, epsfile(`imagedir'frcmedium3e) ht(5) caption(Field is Right of Center)

// SELECTED
graph twoway (line  frcmediumulmedium period if period <= 30) ///
	(connected  frcmediumucmedium period if period <= 30) ///
	(line  frcslowulfast period if period <= 30) ///
	(connected  frcslowucfast period if period <= 30), ///
	ytitle("Average Score") xtitle("Time Period") /// 
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Field Start is Right of Center (0.75)") ///
	note("FLR: Field Learning Rate, ALR: Agent Learning Rate") ///
	legend(cols(1) label(1 Start: Adversarial, (FLR, ALR) = (Medium, Medium))  label(2 Start: Agnostic, (FLR, ALR) = (Medium, Medium)) label(3 Start: Adversarial, (FLR, ALR) = (Slow, Fast)) label(4 Start: Agnostic, (FLR, ALR) = (Slow, Fast)))
graph2tex, epsfile(`imagedir'frcmedium3f) ht(5) caption(Field is Right of Center)

// SELECTED
// Verify this in excel and put it up in the paper
graph twoway (connected  frcmediumulslow period if period <= 20) ///
	(connected  frcmediumucslow period if period <= 20) ///
	(line  frcmediumulfast period if period <= 20) ///
	(line  frcmediumucfast period if period <= 20), ///
	ytitle("Average Score") xtitle("Time Period") /// 
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Field Start is Right of Center (0.75)") ///
	note("FLR: Field Learning Rate, ALR: Agent Learning Rate") ///
	legend(cols(1) label(1 Start: Adversarial, (FLR, ALR) = (Medium, Slow))  label(2 Start: Agnostic, (FLR, ALR) = (Medium, Slow)) label(3 Start: Adversarial, (FLR, ALR) = (Medium, Fast))  label(4 Start: Agnostic, (FLR, ALR) = (Medium, Fast)))
graph2tex, epsfile(`imagedir'frcmedium3g) ht(5) caption(Field is Right of Center with Medium Learning Rate)
