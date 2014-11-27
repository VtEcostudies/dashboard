<%@ page import="grails.converters.JSON" contentType="text/html;charset=UTF-8" %>
<%@page expressionCodec="none" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <title>Data Profile | Atlas of Living Australia</title>
    <link rel="stylesheet" href="${resource(dir: 'css/smoothness', file: 'jquery-ui-1.8.16.custom.css')}"/>
    <gvisualization:apiImport/>
    <r:require modules="jquery-ui, charts, font-awesome, dashboard, jquery.cookie, touch-support, markdown"/>
</head>

<body>

<div class="dashboard">
    <div id="page-header" class="row-fluid">
        <div class="span6 v-center">
            <div class="page-header-content left">
                <ul class="breadcrumb">
                    <li><a href="http://www.ala.org.au" title="Home">Home</a> <span class="icon icon-arrow-right icon-white"></span></li>
                    <li class="active">Dashboard</li>
                </ul>
                <span><i class="icon-exclamation-sign icon-white"></i> HINT -> You can rearrange topics by clicking and dragging them.</span>
            </div>
        </div>
        <div class="span6 v-center">
            <div class="page-header-content button-group">
                <div class="span3 offset2">
                    <a class="btn btn-block" id="resetLayout"><i class="fa fa-refresh"></i> Reset layout</a>
                </div>
                <div class="span3">
                    <a class="btn btn-block" id="downloadCsv"><i class="fa fa-download"></i> Download as CSV</a>
                </div>
                <div class="span3">
                    <a class="btn btn-block" id="showJson"><i class="fa fa-code"></i> Show raw data</a>
                </div>
            </div>
        </div>
    </div>

    <div id="floatContainer">
        <div class="span4" id="records-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">Occurrence records<i class="fa fa-info-circle pull-right hidden"></i>
                    </div>
                </div>
                <div class="panel-body">
                    <p id="totalRecords">
                        <a href="http://biocache.ala.org.au/occurrences/"><db:addCommas value="${totalRecords.total}"/></a>
                    </p>

                    <p class="text-center p1-5">records in total.</p>

                    <p class="third-paragraph">
                        We estimate the number of potential duplicate records to be
                        <a href="${grailsApplication.config.biocache.baseURL}occurrences/search?q=*:*&fq=duplicate_status:D"
                           id="duplicateCount" class="link"><em><db:addCommas value="${totalRecords.duplicates}"/></em></a>.
                    </p>
                </div>
                <div class="panel-body panel-info hidden">
                </div>
            </div>
        </div>
        <div class="span4" id="datasets-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">
                        <a href="http://collections.ala.org.au/datasets"><span class="count">${datasets.total}</span></a>
                        Data sets
                        <i class="fa fa-info-circle pull-right hidden"></i>
                    </div>
                </div>
                <div class="panel-body">
                    <table class="table table-condensed table-striped table-hover">
                        <tr>
                            <td id="website">Harvested websites</td>
                            <td>
                                <span class="count"><db:formatNumber
                                value="${datasets.groups.website}"/></span>
                            </td>
                        </tr>
                        <tr>
                            <td id="records">Occurrence record sets</td>
                            <td><span class="count"><db:formatNumber
                                value="${datasets.groups.records}"/></span>
                            </td>
                        </tr>
                        <tr>
                            <td id="document">Document sets</td>
                            <td><span class="count"><db:formatNumber
                                value="${datasets.groups.document}"/></span>
                            </td>
                        </tr>
                        <tr>
                            <td id="uploads">Uploaded record sets</td>
                            <td><span class="count"><db:formatNumber
                                value="${datasets.groups.uploads}"/></span>
                            </td>
                        </tr>
                    </table>

                    <p class="paragraph">
                        Most recently added dataset is:<br/>
                        <a href="${grailsApplication.config.collectory.baseURL}/public/show/${datasets.last.uid}">
                                <em><db:shorten text="${datasets.last.name}" size="66"/></em></a>
                    </p>

                    <div id="datasets-info" class="info" style="display: none;">
                        <p>Much of the content in the Atlas, such as occurrence records, environmental data, images and the
                        conservation status of species, comes from data sets provided by collecting institutions, individual
                        collectors and community groups.</p>

                        <p>The data sets are listed on the Atlas <a
                                href="http://collections.ala.org.au/datasets/">Datasets page</a>.
                        They can be searched and browsed by category.</p>

                        <p>This infographic shows the number of datasets for the four major categories.</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="span4" id="basis-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">Basis of records<i class="fa fa-info-circle pull-right hidden"></i></div>
                </div>
                <div class="panel-body">
                    <g:if test="${basisOfRecord.error.asBoolean()}">
                        <p class="error" title="${basisOfRecord.reason}">${basisOfRecord.error}</p>
                    </g:if>
                    <table class="table table-condensed table-striped table-hover">
                        <tbody>
                        <g:each in="${basisOfRecord.facets[0..Math.min(4, basisOfRecord?.facets?.size() - 1)]}" var="b">
                            <tr>
                                <td id="br-${b.facet}">${b.display}</td>
                                <td><span class="count">${b.formattedCount}</span></td>
                            </tr>
                        </g:each>
                        </tbody>
                        <g:if test="${basisOfRecord.facets.size() > 5}">
                            <tbody id="moreBasis">
                            <g:each in="${basisOfRecord.facets[5..-1]}" var="b">
                                <tr>
                                    <td id="br-${b.facet}"><div style="display:none;">${b.display}</div></td>
                                    <td><div style="display:none;"><span class="count">${b.formattedCount}</span></div></td>
                                </tr>
                            </g:each>
                            </tbody>
                        </g:if>
                    </table>

                    <p class="paragraph"><span id="moreBasisLink" class="link">more..</span></p>
                </div>
            </div>
        </div>

        <div class="span4" id="collections-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title"><a href="http://collections.ala.org.au"><span class="count">${collections.total}</span></a> Collections<i class="fa fa-info-circle pull-right hidden"></i></div>
                </div>
                <div class="panel-body">
                    <div id="collectionsByCategory">
                        <g:img dir="images" file="spinner.gif"/>
                    </div>
                    <r:script>
                        ${g.remoteFunction(controller: 'charts', action: 'collections', update: 'collectionsByCategory')}
                    </r:script>
                </div>
            </div>
        </div>

        <div class="span4" id="date-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">Records by date<i class="fa fa-info-circle pull-right hidden"></i></div>
                </div>
                <div class="panel-body">
                    <table class="table table-condensed table-striped table-hover">
                        <!--<tr><td id="${dateStats.earliest.uuid}">Earliest record</td><td><span class="count">${dateStats.earliest.display}</span></td>-->
                        <tr><td id="${dateStats.latest.uuid}">Latest record</td><td><span
                                class="count">${dateStats.latest.display}</span></td>
                        <tr><td id="${dateStats.latestImage.uuid}">Last image added</td><td><span
                                class="count">${dateStats.latestImage.display}</span></td>
                        <tr><td id="1600">1600s</td><td><span class="count"><db:formatNumber value="${dateStats.c1600}"/></span>
                        </td>
                        <tr><td id="1700">1700s</td><td><span class="count"><db:formatNumber value="${dateStats.c1700}"/></span>
                        </td>
                        <tr><td id="1800">1800s</td><td><span class="count"><db:formatNumber value="${dateStats.c1800}"/></span>
                        </td>
                        <tr><td id="1900">1900s</td><td><span class="count"><db:formatNumber value="${dateStats.c1900}"/></span>
                        </td>
                        <tr><td id="2000">2000s</td><td><span class="count"><db:formatNumber value="${dateStats.c2000}"/></span>
                        </td>
                    </table>
                </div>
            </div>
        </div>

        <div class="span4" id="nsl-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">National Species Lists<i class="fa fa-info-circle pull-right hidden"></i></div>
                </div>
                <div class="panel-body">
                    <table class="table table-condensed table-striped table-hover">
                        <tbody>
                        <tr><td>Accepted names</td><td><span class="count"><db:formatNumber
                                value="${taxaCounts?.acceptedNames}"/></span></td></tr>
                        <tr><td>Synonyms</td><td><span class="count"><db:formatNumber
                                value="${taxaCounts?.synonymNames}"/></span></td></tr>
                        <tr><td>Species names</td><td><span class="count"><db:formatNumber
                                value="${taxaCounts?.acceptedSpeciesNames}"/></span></td></tr>
                        <tr><td></td><td></td></tr>
                        </tbody>
                        <tbody>
                        <tr><td style="margin-top:20px;">Species with records</td><td><span class="count"><db:formatNumber
                                value="${taxaCounts?.speciesWithRecords}"/></span></td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="span4" id="spatial-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">
                        <a href="http://spatial.ala.org.au/layers"><span class="count">${spatialLayers.total}</span></a> Spatial layers
                        <i class="fa fa-info-circle pull-right hidden"></i>
                    </div>
                </div>
                <div class="panel-body">
                    <table class="table table-condensed table-striped table-hover">
                        <tr><td>Contextual layers</td><td><span class="count">${spatialLayers.groups.contextual}</span></td>
                        </tr>
                        <tr><td>Environmental/grided layers</td><td><span
                                class="count">${spatialLayers.groups.environmental}</span></td></tr>
                    </table>
                    <table class="table table-condensed table-striped table-hover">
                        <tr><td>Terrestrial layers</td><td><span class="count">${spatialLayers.groups.terrestrial}</span></td>
                        </tr>
                        <tr><td>Marine layers</td><td><span class="count">${spatialLayers.groups.marine}</span></td></tr>
                    </table>

                    <div id="moreSpatial" style="display:none;">
                        <table class="table table-condensed table-striped table-hover">
                            <g:each in="${spatialLayers.classification}" var="c">
                                <tr><td>${c.key}</td><td><span class="count">${c.value}</span></td></tr>
                            </g:each>
                        </table>
                    </div>

                    <p style="padding-top: 10px;"><span id="moreSpatialLink" class="link">more..</span></p>
                </div>
            </div>
        </div>

        <div class="span4" id="state-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">Records by state and territory<i class="fa fa-info-circle pull-right hidden"></i></div>
                </div>
                <div class="panel-body">
                    <div id="stateAndTerritoryRecords">
                        <g:img dir="images" file="spinner.gif"/>
                    </div>
                    <r:script>
                        ${g.remoteFunction(controller: 'charts', action: 'stateAndTerritoryRecords', update: 'stateAndTerritoryRecords')}
                    </r:script>
                </div>
            </div>
        </div>

        <div class="span4" id="identifyLife-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">Identify Life<i class="fa fa-info-circle pull-right hidden"></i></div>
                </div>
                <div class="panel-body">

                    <p><span class="item">Identification keys:</span></p>
                    <a target="_blank" href="http://www.identifylife.org/">
                        <g:img dir="images/dashboard" file="identify-life-2.png"/>
                    </a>
                    <a href="http://keycentral.identifylife.org/Secure/KeyStore/List.aspx?t="><span
                            class="count">${identifyLifeCounts.keys}</span></a>
                </div>
            </div>
        </div>

        <div class="span4" id="most-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">Most recorded species<i class="fa fa-info-circle pull-right hidden"></i></div>
                </div>
                <div class="panel-body">
                    <div id="mostRecorded">
                        <g:if test="${mostRecorded.error.asBoolean()}">
                            <p class="error" title="${basisOfRecord.reason}">${mostRecorded.error}</p>
                        </g:if>
                        <table class="table table-condensed table-striped table-hover">
                            <g:each in="${mostRecorded.facets}" var="m">
                                <tr><td id="${m.facet}"><em>${m.name}</em>
                                    <g:if test="${m.common}">- ${m.common}</g:if></td>
                                    <td><span class="count">${m.formattedCount}</span></td>
                                </tr>
                            </g:each>
                        </table>
                    </div>
                    <g:select from="['all lifeforms', 'Plants', 'Animals', 'Birds', 'Reptiles', 'Arthropods',
                                     'Mammals', 'Fish', 'Insects', 'Amphibians', 'Bacteria', 'Fungi']" name="mostSppGroup"/>
                    <g:img style="vertical-align:middle;display:none" id="mostLoadingImg" dir="images" file="spinner.gif"/>
                </div>
            </div>
        </div>

        <div class="span4" id="typeStatus-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">
                        <a href="http://biocache.ala.org.au/occurrences/search?q=type_status:[*%20TO%20*]&fq=-type_status:notatype">
                            <span class="count"><db:formatNumber value="${typeCounts.total}"/></span>
                        </a>
                        Type specimens
                        <i class="fa fa-info-circle pull-right hidden"></i>
                    </div>
                </div>
                <div class="panel-body">
                    <div id="baseTypes">
                        <table class="click-thru table table-condensed table-striped table-hover">
                            <tr><td id="holotype">Holotypes</td><td><span class="count">${typeCounts.holotype}</span></td></tr>
                            <tr><td id="lectotype">Lectotypes</td><td><span class="count">${typeCounts.lectotype}</span></td>
                            </tr>
                            <tr><td id="neotype">Neotypes</td><td><span class="count">${typeCounts.neotype}</span></td></tr>
                            <tr><td id="isotype">Isotypes</td><td><span class="count">${typeCounts.isotype}</span></td></tr>
                        </table>
                        <table>
                            <tr><td>Types with images</td><td><span class="count">${typeCounts.withImage?.total}</span></td>
                            </tr>
                        </table>
                    </div>

                    <div id="moreTypes" style="display:none;">
                        <table class="click-thru table table-condensed table-striped table-hover">
                            <g:each in="${typeCounts}" var="c">
                                <g:if test="${!(c.key in ['total', 'withImage'])}">
                                    <tr><td id="${c.key}">${c.key[0].toUpperCase() + c.key[1..-1]}</td><td><span
                                            class="count">${c.value}</span></td></tr>
                                </g:if>
                            </g:each>
                        </table>
                        <table class="click-thru table table-condensed table-striped table-hover">
                            <g:each in="${typeCounts.withImage}" var="c">
                                <g:if test="${c.key != 'total'}">
                                    <tr><td id="${'image' + c.key}">${c.key[0].toUpperCase() + c.key[1..-1] + ' with image'}</td><td>
                                        <a href="http://biocache.ala.org.au/occurrences/search?q=type_status%3A%5B*+TO+*%5D&fq=-type_status%3Anotatype&fq=multimedia:Image"></a>
                                        <span class="count">${c.value}</span>
                                    </a>
                                    </td></tr>
                                </g:if>
                            </g:each>
                        </table>
                    </div>

                    <p style="padding-top: 10px;"><span id="moreTypesLink" class="link">more..</span></p>
                </div>
            </div>
        </div>

        <div class="span4" id="bold-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">
                        <a target="_blank" href="http://bold.ala.org.au/"> Barcode of life</a><i class="fa fa-info-circle pull-right hidden"></i>
                    </div>
                </div>
                <div class="panel-body">
                    <h5 class="text-center">DNA barcode data <a target="_blank" href="http://bold.ala.org.au/"><g:img dir="images/dashboard" file="bold.png"/></a></h5>
                    <table class="table table-condensed table-striped table-hover">
                        <tbody>
                        <tr><td>Records</td><td><span class="count"><db:formatNumber value="${boldCounts?.records}"/></span>
                        </td></tr>
                        <tr><td>Species</td><td><span class="count"><db:formatNumber value="${boldCounts?.species}"/></span>
                        </td></tr>
                        <tr><td>Countries</td><td><span class="count"><db:formatNumber value="${boldCounts?.countries}"/></span>
                        </td></tr>
                        <tr><td>Institutions</td><td><span class="count"><db:formatNumber
                                value="${boldCounts?.institutions}"/></span></td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="span4" id="bhl-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">Biodiversity heritage library<i class="fa fa-info-circle pull-right hidden"></i></div>
                </div>
                <div class="panel-body">
                    <div class="text-center">
                        <a target="_blank" href="http://bhl.ala.org.au/"><g:img dir="images/dashboard" file="bhl.png"/></a>
                    </div>
                    <table class="table table-condensed table-striped table-hover">
                        <tbody>
                        <tr><td>Pages</td><td><span class="count"><db:formatNumber value="${bhlCounts?.pages}"/></span></td>
                        </tr>
                        <tr><td>Volumes</td><td><span class="count"><db:formatNumber value="${bhlCounts?.volumes}"/></span></td>
                        </tr>
                        <tr><td>Titles</td><td><span class="count"><db:formatNumber value="${bhlCounts?.titles}"/></span></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <g:if test="${volunteerPortalCounts}">
            <div class="span4" id="bvp-topic">
                <div class="panel">
                    <div class="panel-heading">
                        <div class="panel-title">
                            <a target="_blank" href="http://volunteer.ala.org.au/">DigiVol <smaller>(Volunteer portal)</smaller></a>
                            <i class="fa fa-info-circle pull-right hidden"></i>
                        </div>
                    </div>
                    <div class="panel-body">
                        <table class="table table-condensed table-striped table-hover">
                            <tbody>
                            <tr><td>Specimen labels transcribed</td><td><span class="count"><db:formatNumber
                                    value="${volunteerPortalCounts?.specimens}"/></span></td></tr>
                            <tr><td>Fieldnotes pages transcribed</td><td><span class="count"><db:formatNumber
                                    value="${volunteerPortalCounts?.fieldnotes}"/></span></td></tr>
                            <tr><td>Volunteers</td><td><span class="count"><db:formatNumber
                                    value="${volunteerPortalCounts?.volunteerCount}"/></span></td></tr>
                            <tr><td>Expeditions active</td><td><span class="count"><db:formatNumber
                                    value="${volunteerPortalCounts?.activeExpeditionsCount}"/></span></td></tr>
                            <tr><td>Expeditions completed</td><td><span class="count"><db:formatNumber
                                    value="${volunteerPortalCounts?.completedExpeditionsCount}"/></span></td></tr>
                            <tr><td>Total expeditions</td><td><span class="count"><db:formatNumber
                                    value="${volunteerPortalCounts?.expeditionCount}"/></span></td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </g:if>

        <g:if test="${false && volunteerPortalCounts}">
            <div class="span4" id="bvp-topic">
                <div class="panel">
                    <div class="panel-heading">
                        <div class="panel-title"><a target="_blank" href="http://volunteer.ala.org.au/">DigiVol - top volunteers</a><i class="fa fa-info-circle pull-right hidden"></i></div>
                    </div>
                    <div class="panel-body">
                        <table class="click-thru table table-condensed table-striped table-hover">
                            <tbody>
                            <g:each in="${volunteerPortalCounts.topTenVolunteers.take(7)}" var="volunteer">
                                <tr><td>${volunteer[0]}</td><td><span class="count"><db:formatNumber
                                        value="${volunteer[1]}"/></span></td></tr>
                            </g:each>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </g:if>

        <div class="span4" id="conservation-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">Conservation status<i class="fa fa-info-circle pull-right hidden"></i></div>
                </div>
                <div class="panel-body">
                    <table class="click-thru table table-condensed table-striped table-hover">
                        <thead>
                            <tr><th>Status</th><th># species</th></tr>
                        </thead>
                        <tbody>
                        <g:each in="${stateConservation[0..Math.min(6, stateConservation.size() - 1)]}" var="b">
                            <tr>
                                <td id="sc-${b.status}">${b.status}</td>
                                <td><span class="count">${b.species}</span></td>
                            </tr>
                        </g:each>
                        </tbody>
                        <g:if test="${stateConservation.size() > 7}">
                            <tbody id="moreConservation">
                            <g:each in="${stateConservation[7..-1]}" var="b">
                                <tr>
                                    <td id="sc-${b.status}"><div style="display:none;">${b.status}</div></td>
                                    <td><div style="display:none;"><span class="count">${b.species}</span></div></td>
                                </tr>
                            </g:each>
                            </tbody>
                        </g:if>
                    </table>
                    <g:if test="${stateConservation.size() > 7}">
                        <p style="padding-top: 2px;"><span id="moreConservationLink" class="link">more..</span></p>
                    </g:if>
                </div>
            </div>
        </div>

        <div class="span4" id="dataProvider-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">Records by data provider<i class="fa fa-info-circle pull-right hidden"></i></div>
                </div>
                <div class="panel-body">
                    <table class="click-thru table table-condensed table-striped table-hover">
                        <g:each in="${dataProviders[0..Math.min(6, dataProviders.size() - 1)]}" var="b">
                            <tr>
                                <td id="${b.uid}" title="${b.name}"><a href="${b.uri}">
                                    <db:shorten text="${b.display}" size="35"/>
                                </a></td>
                                <td><span class="count">${b.formattedCount}</span></td>
                            </tr>
                        </g:each>
                    </table>
                    <g:if test="${dataProviders.size() > 7}">
                        <div id="moreDataProvider" class="initiallyHidden">
                            <table class="click-thru table table-condensed table-striped table-hover">
                                <g:each in="${dataProviders[7..-1]}" var="b">
                                    <tr>
                                        <td id="${b.uid}" title="${b.name}"><a href="${b.uri}">
                                            <db:shorten text="${b.display}" size="35"/>
                                        </a></td>
                                        <td><span class="count">${b.formattedCount}</span></td>
                                    </tr>
                                </g:each>
                            </table>
                        </div>
                    </g:if>
                    <g:if test="${dataProviders.size() > 7}">
                        <p style="padding-top: 2px;"><span id="moreDataProviderLink" class="link moreLink">more..</span></p>
                    </g:if>
                </div>
            </div>
        </div>

        <div class="span4" id="institutions-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">Records by institution<i class="fa fa-info-circle pull-right hidden"></i></div>
                </div>
                <div class="panel-body">
                    <table class="table table-condensed table-striped table-hover">
                        <g:each in="${institutions[0..Math.min(6, institutions.size() - 1)]}" var="b">
                            <tr>
                                <td id="${b.uid}" title="${b.name}"><a href="${b.uri}"><db:shorten text="${b.display}"
                                                                                                   size="35"/></a></td>
                                <td><span class="count">${b.formattedCount}</span></td>
                            </tr>
                        </g:each>
                    </table>
                    <g:if test="${institutions.size() > 7}">
                        <div id="moreInstitution" class="initiallyHidden">
                            <table class="table table-condensed table-striped table-hover">
                                <g:each in="${institutions[7..-1]}" var="b">
                                    <tr>
                                        <td id="${b.uid}" title="${b.name}"><a href="${b.uri}"><db:shorten text="${b.display}"
                                                                                                           size="35"/></a></td>
                                        <td><span class="count">${b.formattedCount}</span></td>
                                    </tr>
                                </g:each>
                            </table>
                        </div>
                    </g:if>
                    <g:if test="${institutions.size() > 7}">
                        <p style="padding-top: 2px;"><span id="moreInstitutionLink" class="link moreLink">more..</span></p>
                    </g:if>
                </div>
            </div>
        </div>

        <div class="span4" id="lifeform-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">Records by life form<i class="fa fa-info-circle pull-right hidden"></i></div>
                </div>
                <div class="panel-body">
                    <table id="lifeformsTable" class="table table-condensed table-striped table-hover"></table>
                    <a href="javascript:void(0);" id="showAllLifeforms">more/less...</a>
                </div>
            </div>
        </div>

        <div class="span6" id="decade-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">Records and species by decade<i class="fa fa-info-circle pull-right hidden"></i></div>
                </div>
                <div class="panel-body">
                    <div id="recordsAndSpeciesByDecade">
                        <g:img dir="images" file="spinner.gif"/>
                    </div>
                    <r:script>
                        ${g.remoteFunction(controller: 'charts', action: 'recordsAndSpeciesByDecade', update: 'recordsAndSpeciesByDecade')}
                    </r:script>
                </div>
            </div>
        </div>

        <div class="span4" id="tree-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">Occurrence tree<i class="fa fa-info-circle pull-right hidden"></i></div>
                </div>
                <div class="panel-body">
                    <div id="tree"></div>
                </div>
            </div>
        </div>

        <div class="span4" id="event-summary-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">Usage statistics<i class="fa fa-info-circle pull-right hidden"></i></div>
                </div>
                <div class="panel-body">
                    <div id="usageStats">
                        <table class="table table-condensed table-striped table-hover">
                            <tbody>
                            <tr>
                                <td>Records downloaded</td>
                                <td>${loggerTotals["1002"]["events"]} events</td>
                                <td>${loggerTotals["1002"]["records"]} records</td>
                            </tr>
                            <tr>

                            </tr>
                            <tr>
                                <td>Records viewed</td>
                                <td>${loggerTotals["1000"]["events"]} events</td>
                                <td>${loggerTotals["1000"]["records"]} records</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="span6" id="reason-breakdown-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">Occurrence downloads by reason<i class="fa fa-info-circle pull-right hidden"></i></div>
                </div>
                <div class="panel-body">
                    <div id="reasonBreakdown">
                        <table id="loggerReasonBreakdownTable" class="table table-condensed table-striped table-hover">
                            <g:each in="${loggerReasonBreakdown}" var="r" status="rIdx">
                                <tr id="loggerReasonBreakdown-${r[0] == 'TOTAL' ? 'TOTAL' : rIdx}"
                                    class="${rIdx >= 6 && r[0] != 'TOTAL' ? 'hideableRow' : ''}">
                                    <td>${r[0]}</td>
                                    <td>${r[1]} events</td>
                                    <td>${r[2]} records</td>
                                </tr>
                            </g:each>
                            <tr><td colspan="3"><a href="javascript:void(0);" id="showAllLoggerReasons">more/less...</a></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="span4" id="email-breakdown-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">Occurrence downloads by user type<i class="fa fa-info-circle pull-right hidden"></i></div>
                </div>
                <div class="panel-body">
                    <div id="emailBreakdown">
                        <table class="table table-condensed table-striped table-hover">
                            <tr><td>Education</td><td>${loggerEmailBreakdown?.edu?.events} events</td><td>${loggerEmailBreakdown?.edu?.records} records</td></tr>
                            <tr><td>Government</td><td>${loggerEmailBreakdown?.gov?.events} events</td><td>${loggerEmailBreakdown?.gov?.records} records</td></tr>
                            <tr><td>Other</td><td>${loggerEmailBreakdown?.other?.events} events</td><td>${loggerEmailBreakdown?.other?.records} records</td></tr>
                            <tr><td>Unspecified</td><td>${loggerEmailBreakdown?.unspecified?.events} events</td><td>${loggerEmailBreakdown?.unspecified?.records} records</td></tr>
                            <tr><td>TOTAL</td><td>${loggerEmailBreakdown?.total?.events} events</td><td>${loggerEmailBreakdown?.total?.records} records</td></tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="span4" id="images-breakdown-topic">
            <div class="panel">
                <div class="panel-heading">
                    <div class="panel-title">
                        Species images&nbsp;&nbsp;
                        <span class="count"><db:formatNumber value="${imagesBreakdown["speciesWithImages"]}"/></span>
                        <i class="fa fa-info-circle pull-right hidden"></i>
                    </div>
                </div>
                <div class="panel-body">
                    <div id="imagesBreakdown">
                        <table class="table table-condensed table-striped table-hover">
                            <tr><td>Taxa with images</td><td>${imagesBreakdown["taxaWithImages"]}</td></tr>
                            <tr><td>Species with images</td><td>${imagesBreakdown["speciesWithImages"]}</td></tr>
                            <tr><td>Subspecies with images</td><td>${imagesBreakdown["subspeciesWithImages"]}</td></tr>
                            <tr><td>Taxa with images from<br/> DigiVol
                            </td><td>${imagesBreakdown["taxaWithImagesFromVolunteerPortal"]}</td></tr>
                            <tr><td>Taxa with images from<br/> citizen science
                            </td><td>${imagesBreakdown["taxaWithImagesFromCS"]}</td></tr>
                            <tr><td>Total number of images</td><td>${imagesBreakdown["imageTotal"]}</td></tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<r:script>
    var alaWsUrls = {
        collections: '${grailsApplication.config.collectory.baseURL}',
        biocache: '${grailsApplication.config.biocache.baseURL}',
        bie: '${grailsApplication.config.bie.baseURL}',
        app: '${grailsApplication.config.grails.serverURL}'
    }

    <g:applyCodec encodeAs="none">
    var panelInfo = ${panelInfo};
    </g:applyCodec>

    $(function() {
        dashboard.init({
            urls: alaWsUrls
        });
    });
</r:script>
</body>
</html>