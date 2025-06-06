<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns ="http://purl.oclc.org/dsdl/schematron" id="complex-ls-mof-phase-cables-connected-phase">
    <rule context="//nlcs:LSmof[nlcs:Functie = 'OVERGANG 3>1 FASE']">
        <let name="handle"
             value="nlcs:Handle"/>

        <let name="statuses_to_check"
             value="keronic:ls-mof-phase-ls-cable-status-check()"/>

        <let name="pos"
             value="tokenize(normalize-space(nlcs:Geometry/gml:Point/gml:pos), ' ')"/>

        <let name="pos_dimension"
             value="nlcs:Geometry/gml:Point/@srsDimension"/>

        <let name="l1_phase_indications"
             value="keronic:ls-mof-phase-ls-cable-l1-indication()"/>

        <let name="l2_phase_indications"
             value="keronic:ls-mof-phase-ls-cable-l2-indication()"/>

        <let name="l3_phase_indications"
             value="keronic:ls-mof-phase-ls-cable-l3-indication()"/>

        <let name="f3_phase_indications"
             value="keronic:ls-mof-phase-ls-cable-f3-indication()"/>

        <let name="ls_cables_connected"
             value="//nlcs:LSkabel[
                    let $pos_list := tokenize(normalize-space(nlcs:Geometry/gml:LineString/gml:posList))
                    return
                    let $pos_list_dimensions := nlcs:Geometry/gml:LineString/@srsDimension
                    return
                    (some $status_to_check in ($statuses_to_check) satisfies($status_to_check = nlcs:Status))
                    and
                    keronic:point-connected-to-line($pos, $pos_dimension, $pos_list, $pos_list_dimensions)
                    ]"/>

        <let name="ls_cables_l1_connected"
             value="for $ls_cable in $ls_cables_connected return $ls_cable/nlcs:FaseAanduiding[. = $l1_phase_indications]"/>

        <let name="ls_cables_l2_connected"
             value="for $ls_cable in $ls_cables_connected return $ls_cable/nlcs:FaseAanduiding[. = $l2_phase_indications]"/>

        <let name="ls_cables_l3_connected"
             value="for $ls_cable in $ls_cables_connected return $ls_cable/nlcs:FaseAanduiding[. = $l3_phase_indications]"/>

        <let name="ls_cables_f3_connected"
             value="for $ls_cable in $ls_cables_connected return $ls_cable/nlcs:FaseAanduiding[. = $f3_phase_indications]"/>

        <let name="message"
             value="keronic:get-translation('ls_mof_phase_connected_cables_phase')"/>

        <let name="placeholders"
             value="let $map := map{
                    'handle_mof' : $handle,
                    'handle_1' : $ls_cables_connected[position() = 1]/nlcs:Handle,
                    'handle_2' : $ls_cables_connected[position() = 2]/nlcs:Handle,
                    'handle_3' : $ls_cables_connected[position() = 3]/nlcs:Handle,
                    'handle_4' : $ls_cables_connected[position() = 4]/nlcs:Handle,
                    'status_1' : $ls_cables_connected[position() = 1]/nlcs:Status,
                    'status_2' : $ls_cables_connected[position() = 2]/nlcs:Status,
                    'status_3' : $ls_cables_connected[position() = 3]/nlcs:Status,
                    'status_4' : $ls_cables_connected[position() = 4]/nlcs:Status,
                    'l1_count' : count($ls_cables_l1_connected),
                    'l2_count' : count($ls_cables_l2_connected),
                    'l3_count' : count($ls_cables_l3_connected),
                    'f3_count' : count($ls_cables_f3_connected),
                    'checked_statuses' : string-join($statuses_to_check, ', ')
                    }
                    return $map
                    "/>

        <let name="required_count"
             value="xs:integer(keronic:ls-mof-phase-ls-cable-required-count())"
             as="xs:integer"/>

        <assert id="assert-complex-phase-connected-cable-phases" test="if (count($ls_cables_connected) = $required_count)
                      then
                      (
                      (count($ls_cables_l1_connected) = 1) and
                      (count($ls_cables_l2_connected) = 1) and
                      (count($ls_cables_l3_connected) = 1) and
                      (count($ls_cables_f3_connected) = 1)
                      )
                      else
                      true()">
            <value-of select="keronic:replace-placeholders($message, $placeholders)"/>
        </assert>
    </rule>
</pattern>
